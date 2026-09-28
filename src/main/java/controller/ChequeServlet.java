package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import dao.BitacoraDAO;
import dao.ChequeDAO;
import dao.ObjetoGastoDAO;
import dao.ProveedorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cheque;
import model.ObjetoGasto;
import model.Proveedor;

@WebServlet("/ChequeServlet")
public class ChequeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ChequeDAO chequeDAO = new ChequeDAO();
    private ProveedorDAO proveedorDAO = new ProveedorDAO();
    private ObjetoGastoDAO objetoGastoDAO = new ObjetoGastoDAO();
    private BitacoraDAO bitacoraDAO = new BitacoraDAO();

    // DETALLE: solo letras (con tildes/ñ) y espacios.
    private static final java.util.regex.Pattern PATRON_DETALLE =
        java.util.regex.Pattern.compile("^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$");

    // =========================================================
    // GET
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Obtenemos la sesión actual
        HttpSession session = request.getSession(false);

        // Si no hay sesión, regresamos al login
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        // -----------------------------------------------------
        // Abrir formulario para registrar un cheque
        // -----------------------------------------------------
        if ("nuevo".equals(accion)) {

            cargarDatosFormulario(request);

            request.getRequestDispatcher("/views/formulario_cheque.jsp")
                   .forward(request, response);

            return;
        }

        // -----------------------------------------------------
        // Mostrar lista de cheques
        // -----------------------------------------------------

        try {

        	// Obtener los valores de los filtros enviados desde el formulario
        	String fechaInicio = request.getParameter("fechaInicio");
        	String fechaFin = request.getParameter("fechaFin");
        	String numeroCheque = request.getParameter("numeroCheque");
        	String idProveedor = request.getParameter("idProveedor");
        	String estado = request.getParameter("estado");

        	List<Cheque> listaCheques;

        	// Si se utilizó algún filtro, buscar con filtros
        	if ((fechaInicio != null && !fechaInicio.isEmpty()) ||
        	    (fechaFin != null && !fechaFin.isEmpty()) ||
        	    (numeroCheque != null && !numeroCheque.trim().isEmpty()) ||
        	    (idProveedor != null && !idProveedor.isEmpty()) ||
        	    (estado != null && !estado.isEmpty())) {

        	    listaCheques = chequeDAO.buscarConFiltros(
        	        fechaInicio,
        	        fechaFin,
        	        numeroCheque,
        	        idProveedor,
        	        estado
        	    );

        	} else {
        	    // Si no hay filtros, mostrar todos los cheques
        	    listaCheques = chequeDAO.listarTodos();
        	}

        	// Enviar los cheques encontrados a la JSP
        	//
        	// IMPORTANTE (fix):
        	// cheques.jsp lee el atributo con el nombre "cheques"
        	// (request.getAttribute("cheques")), NO "listaCheques".
        	// Por eso la tabla siempre salía vacía aunque hubiera
        	// datos en la base: el nombre del atributo no coincidía
        	// con lo que el JSP estaba buscando.
        	request.setAttribute("cheques", listaCheques);

        	// Enviar proveedores para el filtro
        	request.setAttribute("proveedores", proveedorDAO.listarActivos());

        	// Mostrar la página
        	request.getRequestDispatcher("/views/cheques.jsp").forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            // IMPORTANTE (fix):
            // cheques.jsp lee el atributo "mensajeError", no "error".
            request.setAttribute("mensajeError",
                    "No se pudieron cargar los cheques.");

            request.getRequestDispatcher("/views/cheques.jsp")
                   .forward(request, response);
        }
    }

			 // =========================================================
			 // POST
			 // =========================================================
			 @Override
			 protected void doPost(HttpServletRequest request,
			                       HttpServletResponse response)
			         throws ServletException, IOException {
			
			     request.setCharacterEncoding("UTF-8");
			
			     HttpSession session = request.getSession(false);
			
			     // Verificamos que exista una sesión activa
			     if (session == null || session.getAttribute("idUsuario") == null) {
			
			         response.sendRedirect(
			                 request.getContextPath() + "/views/login.jsp"
			         );
			
			         return;
			     }
			
			     // Obtenemos la acción enviada por el formulario
			     String accion = request.getParameter("accion");
			
			
			     // -----------------------------------------------------
			     // REGISTRAR CHEQUE
			     // -----------------------------------------------------
			
			     if ("registrar".equals(accion)) {
			         registrarCheque(request, response);
			         return;
			     }
			     // -----------------------------------------------------
			     // CAMBIAR ESTADO
			     // -----------------------------------------------------
			
			     if ("cambiarEstado".equals(accion)) {
			         cambiarEstadoCheque(request, response);
			         return;
			     }
			
			
			     // -----------------------------------------------------
			     // ANULAR CHEQUE
			     // -----------------------------------------------------
			
			     if ("anular".equals(accion)) {
			         anularCheque(request, response);
			         return;
			     }
			
			
			     // -----------------------------------------------------
			     // SACAR DE CIRCULACIÓN
			     // -----------------------------------------------------
			
			     if ("sacarCirculacion".equals(accion)) {
			
			         sacarDeCirculacion(request, response);
			
			         return;
			     }
			
			
			     // Si llega una acción desconocida,
			     // regresamos a la lista de cheques.
			
			     response.sendRedirect(
			             request.getContextPath() + "/ChequeServlet"
			     );
			 }

    // =========================================================
    // REGISTRAR CHEQUE
    // =========================================================
    private void registrarCheque(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // -------------------------------------------------
            // Obtenemos los datos enviados desde el formulario
            // -------------------------------------------------

            String numeroCheque = request.getParameter("numeroCheque");
            String fechaChequeTexto = request.getParameter("fechaCheque");
            String idProveedorTexto = request.getParameter("idProveedor");
            String montoTexto = request.getParameter("monto");
            String montoLetras = request.getParameter("montoLetras");
            String detalle = request.getParameter("detalle");
            String idObjetoGastoTexto = request.getParameter("idObjetoGasto");

            // -------------------------------------------------
            // VALIDACIONES
            // -------------------------------------------------

            // Número de cheque obligatorio
            if (numeroCheque == null || numeroCheque.trim().isEmpty()) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El número de cheque es obligatorio."
                );
                return;
            }

            numeroCheque = numeroCheque.trim();

            // Máximo permitido por la base de datos
            if (numeroCheque.length() > 30) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El número de cheque no puede superar los 30 caracteres."
                );
                return;
            }

            // El número del cheque debe contener solamente números
            if (!numeroCheque.matches("\\d+")) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El número de cheque debe contener solamente números."
                );
                return;
            }

            // Fecha obligatoria
            if (fechaChequeTexto == null || fechaChequeTexto.isEmpty()) {
                mostrarFormularioConError(
                        request,
                        response,
                        "La fecha del cheque es obligatoria."
                );
                return;
            }

            Date fechaCheque;

            try {
                fechaCheque = Date.valueOf(fechaChequeTexto);
            } catch (IllegalArgumentException e) {

                mostrarFormularioConError(
                        request,
                        response,
                        "La fecha del cheque no es válida."
                );
                return;
            }

            // Proveedor obligatorio
            if (idProveedorTexto == null || idProveedorTexto.isEmpty()) {
                mostrarFormularioConError(
                        request,
                        response,
                        "Debe seleccionar un proveedor."
                );
                return;
            }

            int idProveedor;

            try {
                idProveedor = Integer.parseInt(idProveedorTexto);
            } catch (NumberFormatException e) {

                mostrarFormularioConError(
                        request,
                        response,
                        "El proveedor seleccionado no es válido."
                );
                return;
            }

            // Monto obligatorio
            if (montoTexto == null || montoTexto.trim().isEmpty()) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El monto es obligatorio."
                );
                return;
            }

            montoTexto = montoTexto.trim();

            // Permitimos solamente números y hasta 2 decimales
            if (!montoTexto.matches("\\d+(\\.\\d{1,2})?")) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El monto debe ser un número válido con máximo 2 decimales."
                );
                return;
            }

            double monto = Double.parseDouble(montoTexto);

            // El monto debe ser mayor que cero
            if (monto <= 0) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El monto debe ser mayor que 0."
                );
                return;
            }

            // Validamos el máximo del DECIMAL(12,2)
            if (monto > 9999999999.99) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El monto supera el máximo permitido."
                );
                return;
            }

            // Monto en letras obligatorio
            if (montoLetras == null || montoLetras.trim().isEmpty()) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El monto en letras es obligatorio."
                );
                return;
            }

            montoLetras = montoLetras.trim();

            if (montoLetras.length() > 300) {
                mostrarFormularioConError(
                        request,
                        response,
                        "El monto en letras no puede superar los 300 caracteres."
                );
                return;
            }

            // Detalle es opcional
            if (detalle != null) {
                detalle = detalle.trim();

                if (detalle.length() > 300) {
                    mostrarFormularioConError(
                            request,
                            response,
                            "El detalle no puede superar los 300 caracteres."
                    );
                    return;
                }

                if (!detalle.isEmpty() &&
                    !PATRON_DETALLE.matcher(detalle).matches()) {
                    mostrarFormularioConError(
                            request,
                            response,
                            "El detalle solo puede contener letras."
                    );
                    return;
                }
            }

            // Objeto de gasto obligatorio
            if (idObjetoGastoTexto == null || idObjetoGastoTexto.isEmpty()) {
                mostrarFormularioConError(
                        request,
                        response,
                        "Debe seleccionar un objeto de gasto."
                );
                return;
            }

            int idObjetoGasto;

            try {
                idObjetoGasto = Integer.parseInt(idObjetoGastoTexto);
            } catch (NumberFormatException e) {

                mostrarFormularioConError(
                        request,
                        response,
                        "El objeto de gasto seleccionado no es válido."
                );
                return;
            }

            // -------------------------------------------------
            // USUARIO DE LA SESIÓN
            // -------------------------------------------------

            int idUsuario = (Integer) request.getSession()
                                             .getAttribute("idUsuario");

            // -------------------------------------------------
            // CREAMOS EL OBJETO CHEQUE
            // -------------------------------------------------

            Cheque cheque = new Cheque();

            cheque.setNumeroCheque(numeroCheque);
            cheque.setFechaCheque(fechaCheque);
            cheque.setIdProveedor(idProveedor);
            cheque.setMonto(monto);
            cheque.setMontoLetras(montoLetras);
            cheque.setDetalle(detalle);
            cheque.setIdObjetoGasto(idObjetoGasto);

            // Todo cheque nuevo comienza como EMITIDO = 1
            cheque.setEstado(1);

            cheque.setIdUsuarioCreacion(idUsuario);

            // -------------------------------------------------
            // GUARDAMOS EN LA BASE DE DATOS
            // -------------------------------------------------

            chequeDAO.insertar(cheque);

            // -------------------------------------------------
            // REGISTRAMOS LA ACCIÓN EN BITÁCORA
            // -------------------------------------------------

            bitacoraDAO.registrarAccion(
                    idUsuario,
                    "CREAR",
                    "cheques",
                    "Se registró el cheque número "
                    + numeroCheque
            );

            // -------------------------------------------------
            // REDIRECCIÓN
            // -------------------------------------------------

            response.sendRedirect(
                    request.getContextPath() + "/ChequeServlet"
            );

        } catch (Exception e) {

            e.printStackTrace();

            mostrarFormularioConError(
                    request,
                    response,
                    "Ocurrió un error al registrar el cheque."
            );
        }
    }

    
    // =========================================================
    // CARGAR PROVEEDORES Y OBJETOS DE GASTO
    // =========================================================
    private void cargarDatosFormulario(HttpServletRequest request) {

        // Cargamos los proveedores activos
        List<Proveedor> proveedores = proveedorDAO.listarActivos();

        // Cargamos los objetos de gasto disponibles
        List<ObjetoGasto> objetosGasto = objetoGastoDAO.listarDisponibles();

        // Obtenemos automáticamente el siguiente número de cheque
        String siguienteNumero = chequeDAO.obtenerSiguienteNumeroCheque();

        // Enviamos los datos al formulario JSP
        request.setAttribute("proveedores", proveedores);
        request.setAttribute("objetosGasto", objetosGasto);
        request.setAttribute("siguienteNumero", siguienteNumero);
    }

    // =========================================================
    // MOSTRAR FORMULARIO CON ERROR
    // =========================================================
    private void mostrarFormularioConError(HttpServletRequest request,
                                           HttpServletResponse response,
                                           String mensaje)
            throws ServletException, IOException {

        request.setAttribute("error", mensaje);

        // Volvemos a cargar los proveedores y objetos de gasto
        cargarDatosFormulario(request);

        request.getRequestDispatcher("/views/formulario_cheque.jsp")
        .forward(request, response);
    }
    
 // =========================================================
 // CAMBIAR ESTADO DEL CHEQUE
 // =========================================================

 // Maneja los cambios normales de estado.
 //
 // Por ejemplo:
 // Emitido -> Pendiente
 // Pendiente -> Cobrado
 //
 // Las reglas de transición también se verifican
 // dentro del DAO.
 private void cambiarEstadoCheque(HttpServletRequest request,
                                  HttpServletResponse response)
         throws ServletException, IOException {

     try {

         // ID del cheque
         String idChequeTexto = request.getParameter("idCheque");

         // Nuevo estado
         String nuevoEstadoTexto = request.getParameter("nuevoEstado");

         if (idChequeTexto == null || nuevoEstadoTexto == null) {

             response.sendRedirect(
                     request.getContextPath() + "/ChequeServlet"
             );

             return;
         }

         int idCheque = Integer.parseInt(idChequeTexto);
         int nuevoEstado = Integer.parseInt(nuevoEstadoTexto);

         // Usuario que realiza la acción
         int idUsuario = (Integer) request.getSession()
                 .getAttribute("idUsuario");

         // Observación opcional
         String observacion = request.getParameter("observacion");

         if (observacion == null) {
             observacion = "";
         }

         // Intentamos cambiar el estado
         boolean cambiado = chequeDAO.cambiarEstado(
                 idCheque,
                 nuevoEstado,
                 idUsuario,
                 observacion
         );

         if (cambiado) {

             // Registramos la acción en bitácora
             bitacoraDAO.registrarAccion(
                     idUsuario,
                     "CAMBIAR_ESTADO",
                     "cheques",
                     "Se cambió el estado del cheque ID "
                     + idCheque
                     + " al estado "
                     + nuevoEstado
             );
         }

         // Regresamos a la lista de cheques
         response.sendRedirect(
                 request.getContextPath() + "/ChequeServlet"
         );

     } catch (Exception e) {

         e.printStackTrace();

         // IMPORTANTE (fix): cheques.jsp lee "mensajeError", no "error".
         request.setAttribute(
                 "mensajeError",
                 "No se pudo cambiar el estado del cheque."
         );

         request.getRequestDispatcher(
                 "/views/cheques.jsp"
         ).forward(request, response);
     }
 }


 // =========================================================
 // ANULAR CHEQUE
 // =========================================================

 // Anula un cheque y guarda el motivo de la anulación.
 private void anularCheque(HttpServletRequest request,
                           HttpServletResponse response)
         throws ServletException, IOException {

     try {

         String idChequeTexto =
                 request.getParameter("idCheque");

         String motivo =
                 request.getParameter("motivo");

         // Validamos el ID
         if (idChequeTexto == null ||
             idChequeTexto.trim().isEmpty()) {

             response.sendRedirect(
                     request.getContextPath() + "/ChequeServlet"
             );

             return;
         }

         // El motivo es obligatorio
         if (motivo == null || motivo.trim().isEmpty()) {

             // IMPORTANTE (fix): cheques.jsp lee "mensajeError", no "error".
             request.setAttribute(
                     "mensajeError",
                     "Debe indicar el motivo de la anulación."
             );

             request.getRequestDispatcher(
                     "/views/cheques.jsp"
             ).forward(request, response);

             return;
         }

         int idCheque =
                 Integer.parseInt(idChequeTexto);

         motivo = motivo.trim();

         // Máximo permitido por la base de datos
         if (motivo.length() > 300) {

             // IMPORTANTE (fix): cheques.jsp lee "mensajeError", no "error".
             request.setAttribute(
                     "mensajeError",
                     "El motivo no puede superar los 300 caracteres."
             );

             request.getRequestDispatcher(
                     "/views/cheques.jsp"
             ).forward(request, response);

             return;
         }

         // Usuario de la sesión
         int idUsuario = (Integer) request.getSession()
                 .getAttribute("idUsuario");

         // Anulamos el cheque
         boolean anulado = chequeDAO.anular(
                 idCheque,
                 idUsuario,
                 motivo
         );

         if (anulado) {

             // Registramos en bitácora
             bitacoraDAO.registrarAccion(
                     idUsuario,
                     "ANULAR",
                     "cheques",
                     "Se anuló el cheque ID "
                     + idCheque
                     + ". Motivo: "
                     + motivo
             );
         }

         response.sendRedirect(
                 request.getContextPath() + "/ChequeServlet"
         );

     } catch (Exception e) {

         e.printStackTrace();

         // IMPORTANTE (fix): cheques.jsp lee "mensajeError", no "error".
         request.setAttribute(
                 "mensajeError",
                 "No se pudo anular el cheque."
         );

         request.getRequestDispatcher(
                 "/views/cheques.jsp"
         ).forward(request, response);
     }
 }


 // =========================================================
 // SACAR CHEQUE DE CIRCULACIÓN
 // =========================================================

 // Cambia el cheque al estado 5 = Sacado de circulación.
 private void sacarDeCirculacion(HttpServletRequest request,
                                 HttpServletResponse response)
         throws ServletException, IOException {

     try {

         String idChequeTexto =
                 request.getParameter("idCheque");

         String observacion =
                 request.getParameter("observacion");

         if (idChequeTexto == null ||
             idChequeTexto.trim().isEmpty()) {

             response.sendRedirect(
                     request.getContextPath() + "/ChequeServlet"
             );

             return;
         }

         int idCheque =
                 Integer.parseInt(idChequeTexto);

         int idUsuario = (Integer) request.getSession()
                 .getAttribute("idUsuario");

         if (observacion == null) {
             observacion = "";
         }

         observacion = observacion.trim();

         // Máximo permitido por la base de datos
         if (observacion.length() > 300) {

             // IMPORTANTE (fix): cheques.jsp lee "mensajeError", no "error".
             request.setAttribute(
                     "mensajeError",
                     "La observación no puede superar los 300 caracteres."
             );

             request.getRequestDispatcher(
                     "/views/cheques.jsp"
             ).forward(request, response);

             return;
         }

         // Estado 5 = Sacado de circulación
         boolean cambiado = chequeDAO.cambiarEstado(
                 idCheque,
                 5,
                 idUsuario,
                 observacion
         );

         if (cambiado) {

             // Registramos la acción en bitácora
             bitacoraDAO.registrarAccion(
                     idUsuario,
                     "SACAR_CIRCULACION",
                     "cheques",
                     "Se sacó de circulación el cheque ID "
                     + idCheque
             );
         }

         response.sendRedirect(
                 request.getContextPath() + "/ChequeServlet"
         );

     } catch (Exception e) {

         e.printStackTrace();

         // IMPORTANTE (fix): cheques.jsp lee "mensajeError", no "error".
         request.setAttribute(
                 "mensajeError",
                 "No se pudo sacar el cheque de circulación."
         );

         request.getRequestDispatcher(
                 "/views/cheques.jsp"
         ).forward(request, response);
     }
 }
}
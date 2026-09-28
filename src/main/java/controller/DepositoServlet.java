package controller;

import java.io.IOException;
import java.util.List;

import dao.DepositoDAO;
import dao.BitacoraDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Deposito;

@WebServlet("/DepositoServlet")
public class DepositoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DepositoDAO depositoDAO;
    private BitacoraDAO bitacoraDAO;

    // MONTO: solo números y hasta 2 decimales.
    private static final java.util.regex.Pattern PATRON_MONTO =
        java.util.regex.Pattern.compile("^\\d+(\\.\\d{1,2})?$");

    // DETALLE: solo letras (con tildes/ñ) y espacios.
    private static final java.util.regex.Pattern PATRON_DETALLE =
        java.util.regex.Pattern.compile("^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$");


    // =========================================================
    // INICIALIZAR SERVLET
    // =========================================================

    @Override
    public void init() throws ServletException {

        depositoDAO = new DepositoDAO();
        bitacoraDAO = new BitacoraDAO();
    }


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Verificar sesión
        if (session == null ||
            session.getAttribute("idUsuario") == null) {

            response.sendRedirect(
                request.getContextPath() +
                "/views/login.jsp"
            );

            return;
        }


        String accion = request.getParameter("accion");


        // =====================================================
        // ABRIR FORMULARIO DE NUEVO DEPÓSITO
        // =====================================================

        if ("nuevo".equals(accion)) {

            String siguienteComprobante =
                depositoDAO.obtenerSiguienteComprobante();

            request.setAttribute(
                "siguienteComprobante",
                siguienteComprobante
            );

            request.getRequestDispatcher(
                "/views/formulario_deposito.jsp"
            ).forward(request, response);

            return;
        }


        // =====================================================
        // OBTENER FILTROS
        // =====================================================

        String fechaInicio =
            request.getParameter("fechaInicio");

        String fechaFin =
            request.getParameter("fechaFin");

        String numeroComprobante =
            request.getParameter("numeroComprobante");

        String tipoDeposito =
            request.getParameter("tipoDeposito");


        // =====================================================
        // BUSCAR DEPÓSITOS
        // =====================================================

        List<Deposito> listaDepositos;

        if ((fechaInicio != null &&
             !fechaInicio.isEmpty()) ||

            (fechaFin != null &&
             !fechaFin.isEmpty()) ||

            (numeroComprobante != null &&
             !numeroComprobante.trim().isEmpty()) ||

            (tipoDeposito != null &&
             !tipoDeposito.isEmpty())) {

            listaDepositos =
                depositoDAO.buscarConFiltros(
                    fechaInicio,
                    fechaFin,
                    numeroComprobante,
                    tipoDeposito
                );

        } else {

            listaDepositos =
                depositoDAO.listarTodos();
        }


        // =====================================================
        // ENVIAR LISTA AL JSP
        // =====================================================

        request.setAttribute(
            "listaDepositos",
            listaDepositos
        );


        // =====================================================
        // MOSTRAR PANTALLA DE DEPÓSITOS
        // =====================================================

        request.getRequestDispatcher(
            "/views/depositos.jsp"
        ).forward(request, response);
    }


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        // =====================================================
        // VERIFICAR SESIÓN
        // =====================================================

        HttpSession session =
            request.getSession(false);

        if (session == null ||
            session.getAttribute("idUsuario") == null) {

            response.sendRedirect(
                request.getContextPath() +
                "/views/login.jsp"
            );

            return;
        }


        // =====================================================
        // OBTENER ACCIÓN
        // =====================================================

        String accion =
            request.getParameter("accion");


        // =====================================================
        // REGISTRAR DEPÓSITO
        // =====================================================

        if ("registrar".equals(accion)) {

            registrarDeposito(
                request,
                response,
                session
            );

            return;
        }


        // =====================================================
        // CAMBIAR ESTADO
        // =====================================================

        if ("cambiarEstado".equals(accion)) {

            cambiarEstadoDeposito(
                request,
                response,
                session
            );

            return;
        }


        // =====================================================
        // ACCIÓN NO RECONOCIDA
        // =====================================================

        response.sendRedirect(
            request.getContextPath() +
            "/DepositoServlet"
        );
    }


    // =========================================================
    // CAMBIAR ESTADO DEL DEPÓSITO
    // =========================================================

    private void cambiarEstadoDeposito(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        try {

            // =================================================
            // OBTENER ID DEL DEPÓSITO
            // =================================================

            int idDeposito =
                Integer.parseInt(
                    request.getParameter("idDeposito")
                );


            // =================================================
            // OBTENER NUEVO ESTADO
            // =================================================

            int nuevoEstado =
                Integer.parseInt(
                    request.getParameter("nuevoEstado")
                );


            System.out.println(
                "ID depósito: " + idDeposito
            );

            System.out.println(
                "Nuevo estado: " + nuevoEstado
            );


            // =================================================
            // VALIDAR ESTADO
            // =================================================

            // 1 = Activo
            // 0 = Inactivo

            if (nuevoEstado != 0 &&
                nuevoEstado != 1) {

                response.sendRedirect(
                    request.getContextPath() +
                    "/DepositoServlet"
                );

                return;
            }


            // =================================================
            // CAMBIAR ESTADO EN LA BASE DE DATOS
            // =================================================

            boolean actualizado =
                depositoDAO.cambiarEstado(
                    idDeposito,
                    nuevoEstado
                );


            // =================================================
            // REGISTRAR EN BITÁCORA
            // =================================================

            if (actualizado) {

                int idUsuario =
                    (Integer) session.getAttribute(
                        "idUsuario"
                    );

                String estadoTexto =
                    (nuevoEstado == 1)
                    ? "ACTIVO"
                    : "INACTIVO";


                bitacoraDAO.registrarAccion(
                    idUsuario,
                    "UPDATE",
                    "depositos",
                    "Se cambió el estado del depósito "
                    + "con ID "
                    + idDeposito
                    + " a "
                    + estadoTexto
                );
            }


            // =================================================
            // REGRESAR A LA LISTA
            // =================================================

            response.sendRedirect(
                request.getContextPath() +
                "/DepositoServlet"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath() +
                "/DepositoServlet"
            );
        }
    }


    // =========================================================
    // REGISTRAR DEPÓSITO
    // =========================================================

    private void registrarDeposito(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        try {

            // =================================================
            // OBTENER DATOS DEL FORMULARIO
            // =================================================

            String tipoDeposito =
                request.getParameter("tipoDeposito");

            String fecha =
                request.getParameter("fecha");

            String monto =
                request.getParameter("monto");

            String detalle =
                request.getParameter("detalle");


            // =================================================
            // VALIDAR CAMPOS OBLIGATORIOS
            // =================================================

            if (tipoDeposito == null ||
                tipoDeposito.isEmpty() ||

                fecha == null ||
                fecha.isEmpty() ||

                monto == null ||
                monto.trim().isEmpty()) {

                mostrarError(
                    request,
                    response,
                    "Todos los campos obligatorios deben completarse."
                );

                return;
            }


            // =================================================
            // VALIDAR TIPO DE DEPÓSITO
            // =================================================

            int tipo =
                Integer.parseInt(tipoDeposito);

            if (tipo != 1 &&
                tipo != 2) {

                mostrarError(
                    request,
                    response,
                    "El tipo de depósito no es válido."
                );

                return;
            }


            // =================================================
            // VALIDAR FECHA
            // =================================================

            java.sql.Date fechaSQL =
                java.sql.Date.valueOf(fecha);


            // =================================================
            // VALIDAR MONTO
            // =================================================

            monto = monto.trim();

            if (!PATRON_MONTO.matcher(monto).matches()) {

                mostrarError(
                    request,
                    response,
                    "El monto debe ser un número válido con máximo 2 decimales."
                );

                return;
            }


            double montoDecimal =
                Double.parseDouble(monto);


            if (montoDecimal <= 0) {

                mostrarError(
                    request,
                    response,
                    "El monto debe ser mayor que 0."
                );

                return;
            }


            // =================================================
            // VALIDAR DETALLE
            // =================================================

            // El detalle es opcional

            if (detalle != null) {

                detalle = detalle.trim();


                // Máximo 300 caracteres

                if (detalle.length() > 300) {

                    mostrarError(
                        request,
                        response,
                        "El detalle no puede superar los 300 caracteres."
                    );

                    return;
                }


                // Solo letras, tildes, ñ y espacios

                if (!detalle.isEmpty() &&
                    !PATRON_DETALLE.matcher(detalle).matches()) {

                    mostrarError(
                        request,
                        response,
                        "El detalle solo puede contener letras."
                    );

                    return;
                }
            }


            // =================================================
            // OBTENER USUARIO DE LA SESIÓN
            // =================================================

            int idUsuario =
                (Integer) session.getAttribute(
                    "idUsuario"
                );


            // =================================================
            // CREAR OBJETO DEPÓSITO
            // =================================================

            Deposito deposito =
                new Deposito();

            deposito.setTipoDeposito(tipo);

            deposito.setFecha(fechaSQL);

            deposito.setMonto(montoDecimal);

            deposito.setDetalle(detalle);

            deposito.setEstado(1);

            deposito.setIdUsuario(idUsuario);


            // =================================================
            // GUARDAR EN BASE DE DATOS
            // =================================================

            boolean registrado =
                depositoDAO.insertar(deposito);


            // =================================================
            // REGISTRAR EN BITÁCORA
            // =================================================

            if (registrado) {

                bitacoraDAO.registrarAccion(
                    idUsuario,
                    "INSERT",
                    "depositos",
                    "Se registró un nuevo depósito "
                    + "con monto de "
                    + montoDecimal
                );


                // =================================================
                // REDIRECCIÓN
                // =================================================

                response.sendRedirect(
                    request.getContextPath() +
                    "/DepositoServlet?mensaje=registrado"
                );

            } else {

                mostrarError(
                    request,
                    response,
                    "No se pudo registrar el depósito."
                );
            }


        } catch (NumberFormatException e) {

            mostrarError(
                request,
                response,
                "Los datos numéricos ingresados no son válidos."
            );


        } catch (IllegalArgumentException e) {

            mostrarError(
                request,
                response,
                "La fecha ingresada no es válida."
            );


        } catch (Exception e) {

            e.printStackTrace();

            mostrarError(
                request,
                response,
                "Ocurrió un error al registrar el depósito."
            );
        }
    }


    // =========================================================
    // MOSTRAR ERROR
    // =========================================================

    private void mostrarError(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje)
            throws ServletException, IOException {

        request.setAttribute(
            "error",
            mensaje
        );


        request.getRequestDispatcher(
            "/views/formulario_deposito.jsp"
        ).forward(request, response);
    }

}
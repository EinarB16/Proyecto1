package controller;

import java.io.IOException;

import dao.ProveedorDAO;
import dao.BitacoraDAO;
import model.Proveedor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Este Servlet controla las operaciones relacionadas con los proveedores.

@WebServlet("/ProveedorServlet")
public class ProveedorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // DAO encargado de comunicarse con la tabla proveedores.
    private ProveedorDAO proveedorDAO = new ProveedorDAO();

    // DAO encargado de registrar las acciones en bitacora.
    private BitacoraDAO bitacoraDAO = new BitacoraDAO();

    // =========================================================
    // PATRONES DE VALIDACIÓN
    // =========================================================

    private static final java.util.regex.Pattern PATRON_RUC =
        java.util.regex.Pattern.compile(
            "^[0-9\\-]+$"
        );

    private static final java.util.regex.Pattern PATRON_NOMBRE =
        java.util.regex.Pattern.compile(
            "^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ .,&'\\-]+$"
        );

    private static final java.util.regex.Pattern PATRON_TELEFONO =
        java.util.regex.Pattern.compile(
            "^[0-9]{3,4}-[0-9]{4}$"
        );

    private static final java.util.regex.Pattern PATRON_CORREO =
        java.util.regex.Pattern.compile(
            "^[a-zA-Z0-9_.]+@[a-zA-Z0-9_.]+$"
        );


    // =========================================================
    // MÉTODO GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
            request.getSession(false);

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/views/login.jsp"
            );

            return;
        }

        String accion =
            request.getParameter("accion");


        // =====================================================
        // NUEVO PROVEEDOR
        // =====================================================

        if ("nuevo".equals(accion)) {

            request.getRequestDispatcher(
                "/views/formulario_proveedor.jsp"
            ).forward(request, response);

            return;
        }


        // =====================================================
        // EDITAR PROVEEDOR
        // =====================================================

        if ("editar".equals(accion)) {

            try {

                int idProveedor =
                    Integer.parseInt(
                        request.getParameter(
                            "idProveedor"
                        )
                    );

                Proveedor proveedor =
                    proveedorDAO.buscarPorId(
                        idProveedor
                    );

                if (proveedor == null) {

                    request.setAttribute(
                        "error",
                        "El proveedor no existe."
                    );

                    request.getRequestDispatcher(
                        "/views/proveedores.jsp"
                    ).forward(request, response);

                    return;
                }

                request.setAttribute(
                    "modoEdicion",
                    true
                );

                request.setAttribute(
                    "proveedor",
                    proveedor
                );

                request.getRequestDispatcher(
                    "/views/formulario_proveedor.jsp"
                ).forward(request, response);

                return;

            } catch (NumberFormatException e) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/ProveedorServlet"
                );

                return;
            }
        }


        // =========================================================
        // FILTROS DE BÚSQUEDA Y VALIDACIÓN EN GET
        // =========================================================

        String nombre =
            request.getParameter("nombre");

        String ruc =
            request.getParameter("ruc");

        String estado =
            request.getParameter("estado");

        if (nombre != null) {
            nombre = nombre.trim();
        }

        if (ruc != null) {
            ruc = ruc.trim();
        }

        if (estado != null) {
            estado = estado.trim();
        }


        // Validamos RUC
        if (ruc != null &&
            !ruc.isEmpty() &&
            !PATRON_RUC.matcher(ruc).matches()) {

            request.setAttribute(
                "error",
                "El filtro RUC contiene caracteres especiales no permitidos."
            );

            ruc = null;
        }


        // Validamos nombre
        if (nombre != null &&
            !nombre.isEmpty() &&
            !PATRON_NOMBRE.matcher(nombre).matches()) {

            request.setAttribute(
                "error",
                "El filtro Nombre contiene caracteres especiales no permitidos."
            );

            nombre = null;
        }


        boolean hayFiltros =
            (nombre != null && !nombre.isEmpty())
            || (ruc != null && !ruc.isEmpty())
            || (estado != null && !estado.isEmpty());


        // =========================================================
        // OBTENER PROVEEDORES
        // =========================================================

        if (hayFiltros) {

            request.setAttribute(
                "proveedores",
                proveedorDAO.buscarConFiltros(
                    nombre,
                    ruc,
                    estado
                )
            );

        } else {

            request.setAttribute(
                "proveedores",
                proveedorDAO.buscarConFiltros(
                    null,
                    null,
                    null
                )
            );
        }


        // =========================================================
        // MOSTRAR LA PÁGINA
        // =========================================================

        request.getRequestDispatcher(
            "/views/proveedores.jsp"
        ).forward(request, response);
    }


    // =========================================================
    // MÉTODO POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
            request.getSession(false);

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/views/login.jsp"
            );

            return;
        }

        request.setCharacterEncoding("UTF-8");

        String accion =
            request.getParameter("accion");


        // =====================================================
        // REGISTRAR
        // =====================================================

        if ("registrar".equals(accion)) {

            registrarProveedor(
                request,
                response,
                session
            );

            return;
        }


        // =====================================================
        // ACTUALIZAR
        // =====================================================

        if ("actualizar".equals(accion)) {

            actualizarProveedor(
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

            cambiarEstadoProveedor(
                request,
                response,
                session
            );

            return;
        }


        response.sendRedirect(
            request.getContextPath()
            + "/ProveedorServlet"
        );
    }


    // =========================================================
    // REGISTRAR PROVEEDOR
    // =========================================================

    private void registrarProveedor(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        String ruc =
            request.getParameter("ruc");

        String nombre =
            request.getParameter("nombre");

        String telefono =
            request.getParameter("telefono");

        String correo =
            request.getParameter("correo");


        // =====================================================
        // VALIDACIONES DE OBLIGATORIEDAD
        // =====================================================

        if (ruc == null ||
            ruc.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "El RUC es obligatorio."
            );

            return;
        }

        if (nombre == null ||
            nombre.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "El nombre del proveedor es obligatorio."
            );

            return;
        }


        ruc = ruc.trim();
        nombre = nombre.trim();

        if (telefono != null) {
            telefono = telefono.trim();
        }

        if (correo != null) {
            correo = correo.trim();
        }


        // =====================================================
        // VALIDAR TAMAÑOS
        // =====================================================

        if (ruc.length() > 20) {

            mostrarError(
                request,
                response,
                "El RUC no puede superar los 20 caracteres."
            );

            return;
        }

        if (nombre.length() > 150) {

            mostrarError(
                request,
                response,
                "El nombre no puede superar los 150 caracteres."
            );

            return;
        }

        if (telefono != null &&
            telefono.length() > 30) {

            mostrarError(
                request,
                response,
                "El teléfono no puede superar los 30 caracteres."
            );

            return;
        }

        if (correo != null &&
            correo.length() > 100) {

            mostrarError(
                request,
                response,
                "El correo no puede superar los 100 caracteres."
            );

            return;
        }


        // =====================================================
        // VALIDACIONES DE FORMATO
        // =====================================================

        if (!PATRON_RUC.matcher(ruc).matches()) {

            mostrarError(
                request,
                response,
                "El RUC solo puede contener números y guiones."
            );

            return;
        }

        if (!PATRON_NOMBRE.matcher(nombre).matches()) {

            mostrarError(
                request,
                response,
                "El nombre contiene caracteres especiales no permitidos."
            );

            return;
        }

        if (telefono != null &&
            !telefono.isEmpty() &&
            !PATRON_TELEFONO.matcher(telefono).matches()) {

            mostrarError(
                request,
                response,
                "El teléfono debe tener un formato válido (ej. 6123-4567)."
            );

            return;
        }

        if (correo != null &&
            !correo.isEmpty() &&
            !PATRON_CORREO.matcher(correo).matches()) {

            mostrarError(
                request,
                response,
                "El correo electrónico no tiene un formato válido."
            );

            return;
        }


        // =====================================================
        // NUEVO: VERIFICAR RUC DUPLICADO
        // =====================================================

        if (proveedorDAO.existeRuc(ruc)) {

            request.setAttribute(
                "error",
                "El RUC " + ruc + " ya fue registrado."
            );

            request.setAttribute(
                "mostrarModalRuc",
                true
            );

            request.setAttribute(
                "modoEdicion",
                false
            );

            request.getRequestDispatcher(
                "/views/formulario_proveedor.jsp"
            ).forward(request, response);

            return;
        }


        // =====================================================
        // CREAR OBJETO PROVEEDOR
        // =====================================================

        Proveedor proveedor =
            new Proveedor();

        proveedor.setRuc(ruc);

        proveedor.setNombre(nombre);

        proveedor.setTelefono(
            (telefono == null ||
             telefono.isEmpty())
                ? null
                : telefono
        );

        proveedor.setCorreo(
            (correo == null ||
             correo.isEmpty())
                ? null
                : correo
        );

        proveedor.setEstado(1);


        // =====================================================
        // USUARIO
        // =====================================================

        int idUsuario =
            (Integer) session.getAttribute(
                "idUsuario"
            );


        // =====================================================
        // GUARDAR
        // =====================================================

        boolean guardado =
            proveedorDAO.insertar(
                proveedor
            );


        // =====================================================
        // BITÁCORA
        // =====================================================

        if (guardado) {

            bitacoraDAO.registrarAccion(
                idUsuario,
                "INSERT",
                "proveedores",
                "Se registró el proveedor "
                + nombre
                + " con RUC "
                + ruc
            );

            response.sendRedirect(
                request.getContextPath()
                + "/ProveedorServlet"
            );

        } else {

            mostrarError(
                request,
                response,
                "No se pudo registrar el proveedor."
            );
        }
    }


    // =========================================================
    // ACTUALIZAR PROVEEDOR
    // =========================================================

    private void actualizarProveedor(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        try {

            // =================================================
            // OBTENER ID
            // =================================================

            int idProveedor =
                Integer.parseInt(
                    request.getParameter(
                        "idProveedor"
                    )
                );


            // =================================================
            // OBTENER DATOS
            // =================================================

            String ruc =
                request.getParameter("ruc");

            String nombre =
                request.getParameter("nombre");

            String telefono =
                request.getParameter("telefono");

            String correo =
                request.getParameter("correo");


            // =================================================
            // VALIDACIONES DE OBLIGATORIEDAD
            // =================================================

            if (ruc == null ||
                ruc.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El RUC es obligatorio.",
                    idProveedor
                );

                return;
            }

            if (nombre == null ||
                nombre.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre del proveedor es obligatorio.",
                    idProveedor
                );

                return;
            }


            ruc = ruc.trim();
            nombre = nombre.trim();

            if (telefono != null) {
                telefono = telefono.trim();
            }

            if (correo != null) {
                correo = correo.trim();
            }


            // =================================================
            // VALIDAR TAMAÑOS
            // =================================================

            if (ruc.length() > 20) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El RUC no puede superar los 20 caracteres.",
                    idProveedor
                );

                return;
            }

            if (nombre.length() > 150) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre no puede superar los 150 caracteres.",
                    idProveedor
                );

                return;
            }

            if (telefono != null &&
                telefono.length() > 30) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El teléfono no puede superar los 30 caracteres.",
                    idProveedor
                );

                return;
            }

            if (correo != null &&
                correo.length() > 100) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El correo no puede superar los 100 caracteres.",
                    idProveedor
                );

                return;
            }


            // =================================================
            // VALIDAR FORMATOS
            // =================================================

            if (!PATRON_RUC.matcher(ruc).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El RUC solo puede contener números y guiones.",
                    idProveedor
                );

                return;
            }

            if (!PATRON_NOMBRE.matcher(nombre).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre contiene caracteres especiales no permitidos.",
                    idProveedor
                );

                return;
            }

            if (telefono != null &&
                !telefono.isEmpty() &&
                !PATRON_TELEFONO.matcher(telefono).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El teléfono debe tener un formato válido (ej. 6123-4567).",
                    idProveedor
                );

                return;
            }

            if (correo != null &&
                !correo.isEmpty() &&
                !PATRON_CORREO.matcher(correo).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El correo electrónico no tiene un formato válido.",
                    idProveedor
                );

                return;
            }


            // =================================================
            // NUEVO: VERIFICAR RUC DUPLICADO AL EDITAR
            // =================================================
            // Excluye al proveedor que estamos editando.

            if (proveedorDAO.existeRuc(
                    ruc,
                    idProveedor)) {

                Proveedor proveedor =
                    proveedorDAO.buscarPorId(
                        idProveedor
                    );

                request.setAttribute(
                    "error",
                    "El RUC " + ruc + " ya fue registrado."
                );

                request.setAttribute(
                    "mostrarModalRuc",
                    true
                );

                request.setAttribute(
                    "modoEdicion",
                    true
                );

                request.setAttribute(
                    "proveedor",
                    proveedor
                );

                request.getRequestDispatcher(
                    "/views/formulario_proveedor.jsp"
                ).forward(request, response);

                return;
            }


            // =================================================
            // CREAR OBJETO PROVEEDOR
            // =================================================

            Proveedor proveedor =
                new Proveedor();

            proveedor.setIdProveedor(
                idProveedor
            );

            proveedor.setRuc(ruc);

            proveedor.setNombre(nombre);

            proveedor.setTelefono(
                (telefono == null ||
                 telefono.isEmpty())
                    ? null
                    : telefono
            );

            proveedor.setCorreo(
                (correo == null ||
                 correo.isEmpty())
                    ? null
                    : correo
            );


            // =================================================
            // ACTUALIZAR EN BD
            // =================================================

            boolean actualizado =
                proveedorDAO.actualizar(
                    proveedor
                );


            // =================================================
            // BITÁCORA
            // =================================================

            if (actualizado) {

                int idUsuario =
                    (Integer) session.getAttribute(
                        "idUsuario"
                    );

                bitacoraDAO.registrarAccion(
                    idUsuario,
                    "UPDATE",
                    "proveedores",
                    "Se actualizó el proveedor "
                    + nombre
                    + " con RUC "
                    + ruc
                    + " e ID "
                    + idProveedor
                );

                response.sendRedirect(
                    request.getContextPath()
                    + "/ProveedorServlet"
                );

            } else {

                mostrarErrorEdicion(
                    request,
                    response,
                    "No se pudo actualizar el proveedor.",
                    idProveedor
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/ProveedorServlet"
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
            "/views/formulario_proveedor.jsp"
        ).forward(request, response);
    }


    // =========================================================
    // MOSTRAR ERROR DE EDICIÓN
    // =========================================================

    private void mostrarErrorEdicion(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje,
            int idProveedor)
            throws ServletException, IOException {

        Proveedor proveedor =
            proveedorDAO.buscarPorId(
                idProveedor
            );

        request.setAttribute(
            "error",
            mensaje
        );

        request.setAttribute(
            "modoEdicion",
            true
        );

        request.setAttribute(
            "proveedor",
            proveedor
        );

        request.getRequestDispatcher(
            "/views/formulario_proveedor.jsp"
        ).forward(request, response);
    }


    // =========================================================
    // CAMBIAR ESTADO DEL PROVEEDOR
    // =========================================================

    private void cambiarEstadoProveedor(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        try {

            int idProveedor =
                Integer.parseInt(
                    request.getParameter(
                        "idProveedor"
                    )
                );

            int nuevoEstado =
                Integer.parseInt(
                    request.getParameter(
                        "nuevoEstado"
                    )
                );

            if (nuevoEstado != 0 &&
                nuevoEstado != 1) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/ProveedorServlet"
                );

                return;
            }

            boolean actualizado =
                proveedorDAO.cambiarEstado(
                    idProveedor,
                    nuevoEstado
                );


            // Solo registramos en bitácora si realmente
            // se realizó la actualización.

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
                    "proveedores",
                    "Se cambió el estado del proveedor "
                    + "con ID "
                    + idProveedor
                    + " a "
                    + estadoTexto
                );
            }

            response.sendRedirect(
                request.getContextPath()
                + "/ProveedorServlet"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/ProveedorServlet"
            );
        }
    }
}
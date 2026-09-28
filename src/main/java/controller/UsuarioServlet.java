package controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import dao.BitacoraDAO;
import dao.UsuarioDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Usuario;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UsuarioDAO usuarioDAO =
        new UsuarioDAO();

    private BitacoraDAO bitacoraDAO =
        new BitacoraDAO();


    // =========================================================
    // PATRONES DE VALIDACIÓN
    // =========================================================

    private static final Pattern PATRON_NOMBRE =
        Pattern.compile(
            "^[a-zA-ZáéíóúÁÉÍÓÚñÑ\\s]+$"
        );

    private static final Pattern PATRON_CORREO =
        Pattern.compile(
            "^[\\w.]+@[a-zA-Z0-9-]+\\.[a-zA-Z]{2,}$"
        );

    private static final List<String> ROLES_VALIDOS =
        Arrays.asList(
            "ADMIN",
            "CONTADOR",
            "AUXILIAR"
        );


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
            request.getSession(false);

        // =====================================================
        // VERIFICAR SESIÓN
        // =====================================================

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/views/login.jsp"
            );

            return;
        }


        Usuario usuarioSesion =
            (Usuario) session.getAttribute(
                "usuario"
            );


        // =====================================================
        // SOLO ADMINISTRADOR
        // =====================================================

        if (!"administrador".equalsIgnoreCase(
                usuarioSesion.getRol())) {

            response.sendRedirect(
                request.getContextPath()
                + "/DashboardServlet"
            );

            return;
        }


        String accion =
            request.getParameter("accion");


        // =====================================================
        // NUEVO USUARIO
        // =====================================================

        if ("nuevo".equals(accion)) {

            request.setAttribute(
                "modoEdicion",
                false
            );

            request.getRequestDispatcher(
                "/views/formulario_usuario.jsp"
            ).forward(
                request,
                response
            );

            return;
        }


        // =====================================================
        // EDITAR USUARIO
        // =====================================================

        if ("editar".equals(accion)) {

            try {

                int idUsuario =
                    Integer.parseInt(
                        request.getParameter(
                            "idUsuario"
                        )
                    );


                Usuario usuario =
                    usuarioDAO.buscarPorId(
                        idUsuario
                    );


                // =================================================
                // USUARIO NO EXISTE
                // =================================================

                if (usuario == null) {

                    request.setAttribute(
                        "error",
                        "El usuario no existe."
                    );

                    request.setAttribute(
                        "usuarios",
                        usuarioDAO.listarTodos()
                    );

                    request.getRequestDispatcher(
                        "/views/usuarios.jsp"
                    ).forward(
                        request,
                        response
                    );

                    return;
                }


                // =================================================
                // ENVIAR DATOS AL FORMULARIO
                // =================================================

                request.setAttribute(
                    "modoEdicion",
                    true
                );

                request.setAttribute(
                    "usuario",
                    usuario
                );


                request.getRequestDispatcher(
                    "/views/formulario_usuario.jsp"
                ).forward(
                    request,
                    response
                );

                return;


            } catch (NumberFormatException e) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/UsuarioServlet"
                );

                return;
            }
        }


        // =====================================================
        // LISTAR USUARIOS
        // =====================================================

        request.setAttribute(
            "usuarios",
            usuarioDAO.listarTodos()
        );


        request.getRequestDispatcher(
            "/views/usuarios.jsp"
        ).forward(
            request,
            response
        );
    }


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
            request.getSession(false);


        // =====================================================
        // VERIFICAR SESIÓN
        // =====================================================

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/views/login.jsp"
            );

            return;
        }


        Usuario usuarioSesion =
            (Usuario) session.getAttribute(
                "usuario"
            );


        // =====================================================
        // SOLO ADMINISTRADOR
        // =====================================================

        if (!"administrador".equalsIgnoreCase(
                usuarioSesion.getRol())) {

            response.sendRedirect(
                request.getContextPath()
                + "/DashboardServlet"
            );

            return;
        }


        request.setCharacterEncoding(
            "UTF-8"
        );


        String accion =
            request.getParameter("accion");


        // =====================================================
        // REGISTRAR
        // =====================================================

        if ("registrar".equals(accion)) {

            registrarUsuario(
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

            actualizarUsuario(
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

            cambiarEstadoUsuario(
                request,
                response,
                session
            );

            return;
        }


        // =====================================================
        // ACCIÓN DESCONOCIDA
        // =====================================================

        response.sendRedirect(
            request.getContextPath()
            + "/UsuarioServlet"
        );
    }


    // =========================================================
    // REGISTRAR USUARIO
    // =========================================================

    private void registrarUsuario(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        String nombre =
            request.getParameter("nombre");

        String apellido =
            request.getParameter("apellido");

        String nombreUsuario =
            request.getParameter("usuario");

        String password =
            request.getParameter("password");

        String correo =
            request.getParameter("correo");

        String rol =
            request.getParameter("rol");


        // =====================================================
        // CAMPOS OBLIGATORIOS
        // =====================================================

        if (nombre == null ||
            nombre.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "El nombre es obligatorio."
            );

            return;
        }


        if (apellido == null ||
            apellido.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "El apellido es obligatorio."
            );

            return;
        }


        if (nombreUsuario == null ||
            nombreUsuario.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "El nombre de usuario es obligatorio."
            );

            return;
        }


        if (password == null ||
            password.isEmpty()) {

            mostrarError(
                request,
                response,
                "La contraseña es obligatoria."
            );

            return;
        }


        if (correo == null ||
            correo.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "El correo es obligatorio."
            );

            return;
        }


        if (rol == null ||
            rol.trim().isEmpty()) {

            mostrarError(
                request,
                response,
                "Debe seleccionar un rol."
            );

            return;
        }


        // =====================================================
        // LIMPIAR DATOS
        // =====================================================

        nombre =
            nombre.trim();

        apellido =
            apellido.trim();

        String usuarioLimpio =
            nombreUsuario.trim();

        correo =
            correo.trim();

        rol =
            rol.trim();


        // =====================================================
        // VALIDAR USUARIO
        // =====================================================

        if (usuarioLimpio.length() < 4) {

            mostrarError(
                request,
                response,
                "El nombre de usuario debe tener al menos 4 caracteres."
            );

            return;
        }


        if (usuarioLimpio.length() > 50) {

            mostrarError(
                request,
                response,
                "El nombre de usuario no puede superar los 50 caracteres."
            );

            return;
        }


        if (usuarioLimpio.contains(" ")) {

            mostrarError(
                request,
                response,
                "El nombre de usuario no puede contener espacios."
            );

            return;
        }


        if (!usuarioLimpio.matches(
                "^[a-zA-Z0-9_.]+$")) {

            mostrarError(
                request,
                response,
                "El nombre de usuario solo puede contener letras, números, puntos y guiones bajos."
            );

            return;
        }


        // =====================================================
        // VERIFICAR USUARIO DUPLICADO
        // =====================================================

        if (usuarioDAO.existeUsuario(
                usuarioLimpio)) {

            mostrarError(
                request,
                response,
                "El nombre de usuario ya se encuentra registrado."
            );

            return;
        }


        // =====================================================
        // LONGITUD
        // =====================================================

        if (nombre.length() > 50) {

            mostrarError(
                request,
                response,
                "El nombre no puede superar los 50 caracteres."
            );

            return;
        }


        if (apellido.length() > 50) {

            mostrarError(
                request,
                response,
                "El apellido no puede superar los 50 caracteres."
            );

            return;
        }


        if (correo.length() > 100) {

            mostrarError(
                request,
                response,
                "El correo no puede superar los 100 caracteres."
            );

            return;
        }


        if (rol.length() > 20) {

            mostrarError(
                request,
                response,
                "El rol no puede superar los 20 caracteres."
            );

            return;
        }


        // =====================================================
        // FORMATO
        // =====================================================

        if (!PATRON_NOMBRE.matcher(
                nombre).matches()) {

            mostrarError(
                request,
                response,
                "El nombre solo puede contener letras."
            );

            return;
        }


        if (!PATRON_NOMBRE.matcher(
                apellido).matches()) {

            mostrarError(
                request,
                response,
                "El apellido solo puede contener letras."
            );

            return;
        }


        if (!PATRON_CORREO.matcher(
                correo).matches()) {

            mostrarError(
                request,
                response,
                "El correo electrónico no tiene un formato válido."
            );

            return;
        }


        // =====================================================
        // CONTRASEÑA
        // =====================================================

        if (password.length() < 6) {

            mostrarError(
                request,
                response,
                "La contraseña debe tener al menos 6 caracteres."
            );

            return;
        }


        // =====================================================
        // ROL
        // =====================================================

        if (!ROLES_VALIDOS.contains(
                rol.toUpperCase())) {

            mostrarError(
                request,
                response,
                "El rol seleccionado no es válido."
            );

            return;
        }


        // =====================================================
        // HASH DE CONTRASEÑA
        // =====================================================

        String passwordHash =
            util.PasswordUtil.generarHash(
                password
            );


        // =====================================================
        // CREAR USUARIO
        // =====================================================

        Usuario usuario =
            new Usuario();

        usuario.setNombre(nombre);
        usuario.setApellido(apellido);
        usuario.setUsuario(usuarioLimpio);
        usuario.setPassword(passwordHash);
        usuario.setCorreo(correo);
        usuario.setRol(rol);
        usuario.setEstado(1);


        // =====================================================
        // ADMINISTRADOR QUE REALIZA LA ACCIÓN
        // =====================================================

        int idUsuarioAdministrador =
            (Integer) session.getAttribute(
                "idUsuario"
            );


        // =====================================================
        // INSERTAR
        // =====================================================

        boolean guardado =
            usuarioDAO.insertar(
                usuario
            );


        if (guardado) {

            // =================================================
            // BITÁCORA
            // =================================================

            bitacoraDAO.registrarAccion(
                idUsuarioAdministrador,
                "INSERT",
                "usuarios",
                "Se registró el usuario "
                + usuarioLimpio
                + " con rol "
                + rol
            );


            response.sendRedirect(
                request.getContextPath()
                + "/UsuarioServlet"
            );

        } else {

            mostrarError(
                request,
                response,
                "No se pudo registrar el usuario."
            );
        }
    }


    // =========================================================
    // ACTUALIZAR USUARIO
    // =========================================================

    private void actualizarUsuario(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        try {

            // =================================================
            // OBTENER ID
            // =================================================

            int idUsuario =
                Integer.parseInt(
                    request.getParameter(
                        "idUsuario"
                    )
                );


            // =================================================
            // OBTENER DATOS
            // =================================================

            String nombre =
                request.getParameter("nombre");

            String apellido =
                request.getParameter("apellido");

            String nombreUsuario =
                request.getParameter("usuario");

            String correo =
                request.getParameter("correo");

            String rol =
                request.getParameter("rol");


            // =================================================
            // CAMPOS OBLIGATORIOS
            // =================================================

            if (nombre == null ||
                nombre.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre es obligatorio.",
                    idUsuario
                );

                return;
            }


            if (apellido == null ||
                apellido.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El apellido es obligatorio.",
                    idUsuario
                );

                return;
            }


            if (nombreUsuario == null ||
                nombreUsuario.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre de usuario es obligatorio.",
                    idUsuario
                );

                return;
            }


            if (correo == null ||
                correo.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El correo es obligatorio.",
                    idUsuario
                );

                return;
            }


            if (rol == null ||
                rol.trim().isEmpty()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "Debe seleccionar un rol.",
                    idUsuario
                );

                return;
            }


            // =================================================
            // LIMPIAR DATOS
            // =================================================

            nombre =
                nombre.trim();

            apellido =
                apellido.trim();

            String usuarioLimpio =
                nombreUsuario.trim();

            correo =
                correo.trim();

            rol =
                rol.trim();


            // =================================================
            // VALIDAR USUARIO
            // =================================================

            if (usuarioLimpio.length() < 4) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre de usuario debe tener al menos 4 caracteres.",
                    idUsuario
                );

                return;
            }


            if (usuarioLimpio.length() > 50) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre de usuario no puede superar los 50 caracteres.",
                    idUsuario
                );

                return;
            }


            if (usuarioLimpio.contains(" ")) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre de usuario no puede contener espacios.",
                    idUsuario
                );

                return;
            }


            if (!usuarioLimpio.matches(
                    "^[a-zA-Z0-9_.]+$")) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre de usuario solo puede contener letras, números, puntos y guiones bajos.",
                    idUsuario
                );

                return;
            }


            // =================================================
            // VERIFICAR USUARIO DUPLICADO
            // =================================================

            if (usuarioDAO.existeUsuario(
                    usuarioLimpio,
                    idUsuario)) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre de usuario ya se encuentra registrado.",
                    idUsuario
                );

                return;
            }


            // =================================================
            // VALIDAR LONGITUD
            // =================================================

            if (nombre.length() > 50) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre no puede superar los 50 caracteres.",
                    idUsuario
                );

                return;
            }


            if (apellido.length() > 50) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El apellido no puede superar los 50 caracteres.",
                    idUsuario
                );

                return;
            }


            if (correo.length() > 100) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El correo no puede superar los 100 caracteres.",
                    idUsuario
                );

                return;
            }


            if (rol.length() > 20) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El rol no puede superar los 20 caracteres.",
                    idUsuario
                );

                return;
            }


            // =================================================
            // VALIDAR FORMATO
            // =================================================

            if (!PATRON_NOMBRE.matcher(
                    nombre).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El nombre solo puede contener letras.",
                    idUsuario
                );

                return;
            }


            if (!PATRON_NOMBRE.matcher(
                    apellido).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El apellido solo puede contener letras.",
                    idUsuario
                );

                return;
            }


            if (!PATRON_CORREO.matcher(
                    correo).matches()) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El correo electrónico no tiene un formato válido.",
                    idUsuario
                );

                return;
            }


            // =================================================
            // VALIDAR ROL
            // =================================================

            if (!ROLES_VALIDOS.contains(
                    rol.toUpperCase())) {

                mostrarErrorEdicion(
                    request,
                    response,
                    "El rol seleccionado no es válido.",
                    idUsuario
                );

                return;
            }


            // =================================================
            // CREAR OBJETO USUARIO
            // =================================================

            Usuario usuario =
                new Usuario();

            usuario.setIdUsuario(
                idUsuario
            );

            usuario.setNombre(
                nombre
            );

            usuario.setApellido(
                apellido
            );

            usuario.setUsuario(
                usuarioLimpio
            );

            usuario.setCorreo(
                correo
            );

            usuario.setRol(
                rol
            );


            // =================================================
            // ACTUALIZAR EN BD
            // =================================================

            boolean actualizado =
                usuarioDAO.actualizar(
                    usuario
                );


            // =================================================
            // BITÁCORA
            // =================================================

            if (actualizado) {

                int idUsuarioAdministrador =
                    (Integer) session.getAttribute(
                        "idUsuario"
                    );


                bitacoraDAO.registrarAccion(
                    idUsuarioAdministrador,
                    "UPDATE",
                    "usuarios",
                    "Se actualizó el usuario "
                    + usuarioLimpio
                    + " con ID "
                    + idUsuario
                );


                response.sendRedirect(
                    request.getContextPath()
                    + "/UsuarioServlet"
                );

            } else {

                mostrarErrorEdicion(
                    request,
                    response,
                    "No se pudo actualizar el usuario.",
                    idUsuario
                );
            }


        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/UsuarioServlet"
            );
        }
    }


    // =========================================================
    // CAMBIAR ESTADO
    // =========================================================

    private void cambiarEstadoUsuario(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        try {

            int idUsuario =
                Integer.parseInt(
                    request.getParameter(
                        "idUsuario"
                    )
                );


            int nuevoEstado =
                Integer.parseInt(
                    request.getParameter(
                        "nuevoEstado"
                    )
                );


            // =================================================
            // SOLO PERMITIMOS 0 O 1
            // =================================================

            if (nuevoEstado != 0 &&
                nuevoEstado != 1) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/UsuarioServlet"
                );

                return;
            }


            // =================================================
            // CAMBIAR EN BD
            // =================================================

            boolean actualizado =
                usuarioDAO.cambiarEstado(
                    idUsuario,
                    nuevoEstado
                );


            // =================================================
            // BITÁCORA
            // =================================================

            if (actualizado) {

                int idUsuarioAdministrador =
                    (Integer) session.getAttribute(
                        "idUsuario"
                    );


                String estadoTexto =
                    nuevoEstado == 1
                    ? "ACTIVO"
                    : "INACTIVO";


                bitacoraDAO.registrarAccion(
                    idUsuarioAdministrador,
                    "UPDATE",
                    "usuarios",
                    "Se cambió el estado del usuario "
                    + "con ID "
                    + idUsuario
                    + " a "
                    + estadoTexto
                );
            }


            response.sendRedirect(
                request.getContextPath()
                + "/UsuarioServlet"
            );


        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/UsuarioServlet"
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

        request.setAttribute(
            "modoEdicion",
            false
        );


        request.getRequestDispatcher(
            "/views/formulario_usuario.jsp"
        ).forward(
            request,
            response
        );
    }


    // =========================================================
    // MOSTRAR ERROR DE EDICIÓN
    // =========================================================

    private void mostrarErrorEdicion(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje,
            int idUsuario)
            throws ServletException, IOException {

        Usuario usuario =
            usuarioDAO.buscarPorId(
                idUsuario
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
            "usuario",
            usuario
        );


        request.getRequestDispatcher(
            "/views/formulario_usuario.jsp"
        ).forward(
            request,
            response
        );
    }
}
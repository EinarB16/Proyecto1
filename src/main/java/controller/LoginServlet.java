package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.UsuarioDAO;
import dao.EntradaSalidaDAO;
import dao.BitacoraDAO;
import model.Usuario;
import util.PasswordUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private EntradaSalidaDAO entradaSalidaDAO = new EntradaSalidaDAO();
    private BitacoraDAO bitacoraDAO = new BitacoraDAO();

    // Solo permitimos letras (con tildes/ñ) y números en el NOMBRE DE USUARIO.
    private static final java.util.regex.Pattern PATRON_USUARIO =
        java.util.regex.Pattern.compile("^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ]+$");

    @Override
    protected void doGet(
            HttpServletRequest request, 
            HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/views/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String nombreUsuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        // =====================================================
        // VALIDACIÓN: CAMPOS VACÍOS Y FORMATO DE USUARIO
        // =====================================================
        if (nombreUsuario == null || nombreUsuario.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Por favor, ingrese usuario y contraseña.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // Se valida el nombre de usuario contra caracteres especiales
        if (!PATRON_USUARIO.matcher(nombreUsuario.trim()).matches()) {

            request.setAttribute(
                    "error",
                    "El nombre de usuario solo puede contener letras y números."
            );

            request.getRequestDispatcher("/views/login.jsp")
                   .forward(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.buscarPorUsuario(nombreUsuario.trim());

        if (usuario == null) {
            request.setAttribute(
                    "error",
                    "El usuario o la contraseña son incorrectos."
            );

            request.getRequestDispatcher("/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Comprobamos si la cuenta está activa.
        if (usuario.getEstado() != 1) {
            request.setAttribute(
                    "error",
                    "La cuenta está inactiva."
            );
            request.getRequestDispatcher("/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Comprobamos si la cuenta está bloqueada.
        if (usuarioDAO.estaBloqueado(usuario)) {

            request.setAttribute(
                    "error",
                    "La cuenta está bloqueada temporalmente. Intente nuevamente en unos minutos."
            );

            request.getRequestDispatcher("/views/login.jsp")
                   .forward(request, response);

            return;
        }

        boolean passwordCorrecta =
                PasswordUtil.verificarPassword(
                        password,
                        usuario.getPassword()
                );

        if (!passwordCorrecta) {
            // Aumentamos el contador de intentos fallidos.
            usuarioDAO.aumentarIntentosFallidos(
                    usuario.getIdUsuario()
            );
            
            // Calculamos cuántos intentos lleva.
            int intentosActuales = usuario.getIntentosFallidos() + 1;
            
            // Si llega a 3 intentos, bloqueamos la cuenta.
            if (intentosActuales >= 3) {
                usuarioDAO.bloquearUsuario(
                        usuario.getIdUsuario()
                );
                request.setAttribute(
                        "error",
                        "Ha alcanzado el máximo de intentos. Su cuenta ha sido bloqueada durante 5 minutos."
                );
            } else {
                request.setAttribute(
                        "error",
                        "El usuario o la contraseña son incorrectos. Intentos restantes: "
                        + (3 - intentosActuales)
                );
            }
            request.getRequestDispatcher("/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // La contraseña es correcta. Reiniciamos intentos.
        usuarioDAO.reiniciarIntentos(usuario.getIdUsuario());

        // Registramos entrada en BD y Bitácora.
        int idLog = entradaSalidaDAO.registrarEntrada(usuario.getIdUsuario());
        
        bitacoraDAO.registrarAccion(
                usuario.getIdUsuario(),
                "LOGIN",
                "usuarios",
                "El usuario " + usuario.getUsuario() + " inició sesión correctamente."
        );

        // Guardamos atributos en la sesión HTTP.
        HttpSession session = request.getSession();
        session.setAttribute("usuario", usuario);
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("nombreUsuario", usuario.getUsuario());
        session.setAttribute("rol", usuario.getRol());
        session.setAttribute("idLogEntrada", idLog);

        // Redirección al Dashboard.
        response.sendRedirect(
                request.getContextPath() + "/DashboardServlet"
        );
    }
}
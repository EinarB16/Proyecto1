package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.EntradaSalidaDAO;
import dao.BitacoraDAO;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EntradaSalidaDAO entradaSalidaDAO = new EntradaSalidaDAO();
    private BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtenemos la sesión actual.
        HttpSession session = request.getSession(false);
        // Comprobamos que exista una sesión.
        if (session != null) {
        	
        	// Obtenemos los datos del usuario que está cerrando sesión.
        	Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        	String nombreUsuario = (String) session.getAttribute("nombreUsuario");
        	
            // Recuperamos el ID del registro de entrada que guardamos cuando el usuario inició sesión.
            Object idLogObjeto = session.getAttribute("idLogEntrada");
            // Comprobamos que exista el ID del registro.
            if (idLogObjeto != null) {
                int idLog = (Integer) idLogObjeto;
                // Registramos la fecha y hora de salida.
                entradaSalidaDAO.registrarSalida(idLog);
            }
            // Cerramos la sesión.
            session.invalidate();
        }
        // Regresamos a la pantalla de inicio de sesión.
        response.sendRedirect(
                request.getContextPath() + "/views/login.jsp"
        );
    }
}
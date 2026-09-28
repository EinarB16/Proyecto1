package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Este filtro protege las páginas internas del sistema.
// Si el usuario no tiene una sesión iniciada,
// será enviado nuevamente al login.
@WebFilter(urlPatterns = {
	    "/DashboardServlet",
	    "/ChequeServlet",
	    "/DepositoServlet",
	    "/ConciliacionServlet"
	})
public class AutenticacionFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        // Convertimos las solicitudes a solicitudes HTTP
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Obtenemos la sesión existente.
        // false significa que NO se crea una nueva sesión.
        HttpSession session = req.getSession(false);

        // Comprobamos si existe una sesión y si contiene al usuario.
        boolean usuarioLogueado =
                session != null &&
                session.getAttribute("usuario") != null;

        if (usuarioLogueado) {

            // Si hay sesión, permitimos continuar
            // hacia la página solicitada.
            chain.doFilter(request, response);

        } else {

            // Si no hay sesión, enviamos al usuario al login.
            resp.sendRedirect(
                req.getContextPath() + "/views/login.jsp"
            );
        }
    }
}
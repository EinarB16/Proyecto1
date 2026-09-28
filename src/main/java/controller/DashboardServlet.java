package controller;

import java.io.IOException;
import java.math.BigDecimal;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =========================================================
        // VERIFICAR SESIÓN
        // =========================================================

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/views/login.jsp"
            );

            return;
        }


        // =========================================================
        // OBTENER ESTADÍSTICAS
        // =========================================================

        DashboardDAO dashboardDAO = new DashboardDAO();

        int totalChequesEmitidos =
                dashboardDAO.obtenerTotalChequesEmitidos();

        int totalChequesPendientes =
                dashboardDAO.obtenerTotalChequesPendientes();

        int totalChequesAnulados =
                dashboardDAO.obtenerTotalChequesAnulados();

        int totalDepositos =
                dashboardDAO.obtenerTotalDepositos();

        BigDecimal montoTotalCheques =
                dashboardDAO.obtenerMontoTotalCheques();

        BigDecimal montoTotalDepositos =
                dashboardDAO.obtenerMontoTotalDepositos();

        String ultimaConciliacion =
                dashboardDAO.obtenerUltimaConciliacion();


        // =========================================================
        // ENVIAR DATOS AL JSP
        // =========================================================

        request.setAttribute(
                "totalChequesEmitidos",
                totalChequesEmitidos
        );

        request.setAttribute(
                "totalChequesPendientes",
                totalChequesPendientes
        );

        request.setAttribute(
                "totalChequesAnulados",
                totalChequesAnulados
        );

        request.setAttribute(
                "totalDepositos",
                totalDepositos
        );

        request.setAttribute(
                "montoTotalCheques",
                montoTotalCheques
        );

        request.setAttribute(
                "montoTotalDepositos",
                montoTotalDepositos
        );

        request.setAttribute(
                "ultimaConciliacion",
                ultimaConciliacion
        );


        // =========================================================
        // MOSTRAR DASHBOARD
        // =========================================================

        request.getRequestDispatcher(
                "/views/dashboard.jsp"
        ).forward(request, response);
    }
}
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import config.Conexion;

@WebServlet("/prueba-conexion")
public class PruebaConexionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Intentamos obtener una conexión con la base de datos.
        if (Conexion.conectar() != null) {

            response.getWriter().println(
                    "Conexion con la base de datos exitosa."
            );

        } else {

            response.getWriter().println(
                    "No se pudo conectar con la base de datos."
            );
        }
    }
}
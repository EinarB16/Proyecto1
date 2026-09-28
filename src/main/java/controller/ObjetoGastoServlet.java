package controller;

import java.io.IOException;
import java.util.List;

import dao.BitacoraDAO;
import dao.ObjetoGastoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ObjetoGasto;

@WebServlet("/ObjetoGastoServlet")
public class ObjetoGastoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ObjetoGastoDAO objetoGastoDAO = new ObjetoGastoDAO();
    private BitacoraDAO bitacoraDAO = new BitacoraDAO();

    // El código del objeto de gasto se maneja como un código numérico.
    private static final java.util.regex.Pattern PATRON_CODIGO =
            java.util.regex.Pattern.compile("^\\d+$");

    // La descripción permite letras, números, espacios y algunos signos básicos.
    private static final java.util.regex.Pattern PATRON_DESCRIPCION =
            java.util.regex.Pattern.compile("^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ .,&'\\-]+$");

    // Solo se permiten los tipos que existen actualmente en objeto_gasto.
    private boolean tipoValido(int tipo) {
        return tipo == 1 || tipo == 2 || tipo == 3 || tipo == 6;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Si no existe una sesión activa, regresamos al login.
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/views/login.jsp"
            );
            return;
        }

        // Cargamos los objetos existentes para mostrarlos en la página.
        cargarObjetos(request);

        request.getRequestDispatcher(
                "/views/objetos_gasto.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Verificamos que exista una sesión activa.
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/views/login.jsp"
            );
            return;
        }

        String codigo = request.getParameter("codigo");
        String descripcion = request.getParameter("descripcion");
        String estadoTexto = request.getParameter("estado");

        // Limpiamos los espacios innecesarios antes de validar.
        if (codigo != null) {
            codigo = codigo.trim();
        }

        if (descripcion != null) {
            descripcion = descripcion.trim();
        }

        if (estadoTexto != null) {
            estadoTexto = estadoTexto.trim();
        }

        String error = null;
        int estado = 0;

        // Validamos el código.
        if (codigo == null || codigo.isEmpty()) {
            error = "El código del objeto de gasto es obligatorio.";
        } else if (codigo.length() > 20) {
            error = "El código no puede superar los 20 caracteres.";
        } else if (!PATRON_CODIGO.matcher(codigo).matches()) {
            error = "El código debe contener solamente números.";
        }

        // Validamos la descripción.
        if (error == null && (descripcion == null || descripcion.isEmpty())) {
            error = "La descripción del objeto de gasto es obligatoria.";
        } else if (error == null && descripcion.length() > 300) {
            error = "La descripción no puede superar los 300 caracteres.";
        } else if (error == null && !PATRON_DESCRIPCION.matcher(descripcion).matches()) {
            error = "La descripción contiene caracteres no permitidos.";
        }

        // Validamos el tipo seleccionado.
        if (error == null) {
            try {
                estado = Integer.parseInt(estadoTexto);

                if (!tipoValido(estado)) {
                    error = "El tipo de objeto de gasto seleccionado no es válido.";
                }

            } catch (NumberFormatException e) {
                error = "Debe seleccionar un tipo de objeto de gasto.";
            }
        }

        // Verificamos que el código no esté repetido.
        if (error == null && objetoGastoDAO.existeCodigo(codigo)) {
            error = "Ya existe un objeto de gasto con ese código.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("codigo", codigo);
            request.setAttribute("descripcion", descripcion);
            request.setAttribute("estado", estadoTexto);
            cargarObjetos(request);

            request.getRequestDispatcher(
                    "/views/objetos_gasto.jsp"
            ).forward(request, response);
            return;
        }

        // Creamos el objeto con los datos validados.
        ObjetoGasto objeto = new ObjetoGasto();
        objeto.setCodigo(codigo);
        objeto.setDescripcion(descripcion);
        objeto.setEstado(estado);

        try {

            if (objetoGastoDAO.insertar(objeto)) {

                // Registramos la acción en la bitácora.
                Object idUsuarioObj = session.getAttribute("idUsuario");

                if (idUsuarioObj != null) {
                    int idUsuario = Integer.parseInt(idUsuarioObj.toString());

                    bitacoraDAO.registrarAccion(
                            idUsuario,
                            "CREAR",
                            "objeto_gasto",
                            "Se registró el objeto de gasto " + codigo
                    );
                }

                response.sendRedirect(
                        request.getContextPath()
                        + "/ObjetoGastoServlet?mensaje=Objeto+de+gasto+registrado+correctamente"
                );

            } else {
                request.setAttribute(
                        "error",
                        "No se pudo registrar el objeto de gasto."
                );
                cargarObjetos(request);

                request.getRequestDispatcher(
                        "/views/objetos_gasto.jsp"
                ).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Ocurrió un error al registrar el objeto de gasto."
            );
            cargarObjetos(request);

            request.getRequestDispatcher(
                    "/views/objetos_gasto.jsp"
            ).forward(request, response);
        }
    }

    // Carga los objetos de gasto disponibles para mostrarlos en la página.
    private void cargarObjetos(HttpServletRequest request) {
        List<ObjetoGasto> objetos = objetoGastoDAO.listarDisponibles();
        request.setAttribute("objetosGasto", objetos);
    }
}

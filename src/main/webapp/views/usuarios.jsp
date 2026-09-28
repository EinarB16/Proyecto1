<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Usuario" %>

<%!
// Convierte algunos caracteres para mostrarlos de forma segura en la página
private String escaparHtml(String texto) {
    if (texto == null) return "";
    return texto.replace("&", "&amp;")
               .replace("<", "&lt;")
               .replace(">", "&gt;")
               .replace("\"", "&quot;")
               .replace("'", "&#39;");
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuarios - Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            background: #f3f5f7;
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
        }

        .barra-superior {
            background: #263445 !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
        }

        .navbar-brand {
            font-weight: 600;
        }

        .contenido-principal {
            width: calc(100% - 40px);
            max-width: 1380px;
            margin: 30px auto;
            padding-bottom: 30px;
        }

        .titulo-pagina {
            color: #263445;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .subtitulo-pagina {
            color: #6c757d;
            margin-bottom: 0;
        }

        .btn-principal {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 16px;
        }

        .btn-principal:hover {
            background: #345d86;
        }

        .tarjeta-tabla {
            border: none;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .cabecera-tabla {
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            padding: 16px 20px;
        }

        .titulo-tabla {
            color: #263445;
            font-weight: 600;
            margin: 0;
        }

        .tabla-usuarios {
            margin-bottom: 0;
        }

        .tabla-usuarios thead th {
            background: #eef1f5;
            color: #344054;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            border-bottom: 1px solid #dfe3e8;
        }

        .tabla-usuarios tbody td {
            font-size: 14px;
            vertical-align: middle;
        }

        .tabla-usuarios tbody tr:hover {
            background: #f8f9fa;
        }

        .estado-badge {
            font-size: 12px;
            padding: 6px 9px;
            border-radius: 6px;
        }

        .acciones {
            min-width: 175px;
            white-space: nowrap;
        }

        .acciones .btn {
            border-radius: 7px;
            font-size: 12px;
            margin-right: 3px;
            margin-bottom: 3px;
        }

        .mensaje-vacio {
            padding: 35px !important;
        }

        .modal-content {
            border: none;
            border-radius: 14px;
            overflow: hidden;
        }

        .modal-header {
            background: #263445;
            color: white;
        }

        .modal-header .btn-close {
            filter: invert(1);
        }

        .modal-footer {
            background: #f8f9fa;
        }

        .boton-dashboard {
            border-radius: 8px;
        }

        @media (max-width: 768px) {
            .contenido-principal {
                width: calc(100% - 30px);
                margin: 20px auto;
            }

            .encabezado-pagina {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 15px;
            }

            .encabezado-pagina .btn {
                width: 100%;
            }

            .acciones {
                min-width: 160px;
            }
        }
    </style>
</head>

<body>

    <!-- Incluye el menú del sistema -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Barra superior con el usuario que inició sesión -->
    <nav class="navbar navbar-dark barra-superior">
        <div class="container-fluid px-4">
            <span class="navbar-brand">Conciliación Bancaria</span>

            <div class="d-flex align-items-center">
                <span class="text-white me-3">
                    Bienvenido, <strong><%= session.getAttribute("nombreUsuario") %></strong>
                </span>

                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-light btn-sm">
                    Cerrar sesión
                </a>
            </div>
        </div>
    </nav>

    <div class="container contenido-principal">

        <!-- Encabezado de la sección de usuarios -->
        <div class="d-flex justify-content-between align-items-center encabezado-pagina mb-4">
            <div>
                <h2 class="titulo-pagina">Usuarios</h2>
                <p class="subtitulo-pagina">Administración de los usuarios registrados en el sistema.</p>
            </div>

            <!-- Lleva al formulario para registrar un usuario -->
            <a href="<%= request.getContextPath() %>/UsuarioServlet?accion=nuevo" class="btn btn-principal text-white">
                + Nuevo usuario
            </a>
        </div>

        <!-- Muestra el mensaje cuando una operación se realizó correctamente -->
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= escaparHtml((String) request.getAttribute("mensaje")) %>

                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Muestra el mensaje cuando ocurre algún error -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= escaparHtml((String) request.getAttribute("error")) %>

                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <%
            // Obtiene del servlet la lista de usuarios
            List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
        %>

        <!-- Tabla donde se muestran los usuarios -->
        <div class="card tarjeta-tabla">

            <div class="cabecera-tabla">
                <h5 class="titulo-tabla">Usuarios registrados</h5>
            </div>

            <div class="card-body p-0">
                <div class="table-responsive">

                    <table class="table table-hover align-middle tabla-usuarios">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Usuario</th>
                                <th>Correo</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>

                        <%
                            // Primero verificamos si existen usuarios
                            if (usuarios != null && !usuarios.isEmpty()) {

                                // Recorremos la lista para mostrar cada usuario
                                for (Usuario usuario : usuarios) {

                                    // Unimos el nombre y apellido para mostrarlo completo
                                    String nombreCompleto = usuario.getNombre() + " " + usuario.getApellido();

                                    // Variable para mostrar el nombre del rol
                                    String rolTexto = "";

                                    // Cambiamos el código del rol por un nombre más entendible
                                    if ("ADMIN".equalsIgnoreCase(usuario.getRol())) {
                                        rolTexto = "Administrador";
                                    } else if ("CONTADOR".equalsIgnoreCase(usuario.getRol())) {
                                        rolTexto = "Contador";
                                    } else {
                                        rolTexto = usuario.getRol();
                                    }
                        %>

                            <tr>

                                <!-- Datos básicos del usuario -->
                                <td><%= escaparHtml(nombreCompleto) %></td>
                                <td><%= escaparHtml(usuario.getUsuario()) %></td>
                                <td><%= escaparHtml(usuario.getCorreo()) %></td>
                                <td><%= escaparHtml(rolTexto) %></td>

                                <!-- Muestra si el usuario está activo o inactivo -->
                                <td>
                                    <% if (usuario.getEstado() == 1) { %>

                                        <span class="badge bg-success estado-badge">
                                            Activo
                                        </span>

                                    <% } else { %>

                                        <span class="badge bg-secondary estado-badge">
                                            Inactivo
                                        </span>

                                    <% } %>
                                </td>

                                <!-- Botones para editar o cambiar el estado -->
                                <td class="acciones">

                                    <!-- Lleva al formulario para editar el usuario -->
                                    <a href="<%= request.getContextPath() %>/UsuarioServlet?accion=editar&idUsuario=<%= usuario.getIdUsuario() %>"
                                       class="btn btn-sm btn-outline-primary">
                                        Editar
                                    </a>

                                    <% if (usuario.getEstado() == 1) { %>

                                        <!-- Si está activo, permite desactivarlo -->
                                        <button type="button"
                                                class="btn btn-sm btn-outline-danger"
                                                onclick="confirmarCambioEstado(<%= usuario.getIdUsuario() %>, 0, '<%= escaparHtml(usuario.getUsuario()) %>')">
                                            Desactivar
                                        </button>

                                    <% } else { %>

                                        <!-- Si está inactivo, permite activarlo -->
                                        <button type="button"
                                                class="btn btn-sm btn-outline-success"
                                                onclick="confirmarCambioEstado(<%= usuario.getIdUsuario() %>, 1, '<%= escaparHtml(usuario.getUsuario()) %>')">
                                            Activar
                                        </button>

                                    <% } %>

                                </td>
                            </tr>

                        <%
                                }

                            } else {
                        %>

                            <!-- Se muestra cuando no hay usuarios registrados -->
                            <tr>
                                <td colspan="6" class="text-center text-muted mensaje-vacio">
                                    No hay usuarios registrados.
                                </td>
                            </tr>

                        <%
                            }
                        %>

                        </tbody>
                    </table>

                </div>
            </div>
        </div>

        <!-- Botón para regresar al dashboard -->
        <div class="mt-3">
            <a href="<%= request.getContextPath() %>/DashboardServlet" class="btn btn-secondary boton-dashboard">
                Regresar al Dashboard
            </a>
        </div>

    </div>

    <!-- Modal que pide confirmación antes de cambiar el estado -->
    <div class="modal fade" id="modalEstado" tabindex="-1" aria-labelledby="modalEstadoLabel" aria-hidden="true">

        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="modalEstadoLabel">
                        Confirmar cambio de estado
                    </h5>

                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <p id="mensajeEstado"></p>
                </div>

                <div class="modal-footer">

                    <!-- Cierra el modal sin hacer cambios -->
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>

                    <!-- Formulario que envía el cambio de estado al servlet -->
                    <form id="formCambiarEstado"
                          method="post"
                          action="<%= request.getContextPath() %>/UsuarioServlet">

                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" id="idUsuarioEstado" name="idUsuario">
                        <input type="hidden" id="nuevoEstado" name="nuevoEstado">

                        <button type="submit" id="btnConfirmarEstado" class="btn btn-primary">
                            Confirmar
                        </button>

                    </form>
                </div>

            </div>
        </div>
    </div>

    <script>
        // Prepara el cambio de estado antes de mostrar la confirmación
        function confirmarCambioEstado(idUsuario, nuevoEstado, nombreUsuario) {

            // Guardamos los datos que se enviarán al servlet
            document.getElementById("idUsuarioEstado").value = idUsuario;
            document.getElementById("nuevoEstado").value = nuevoEstado;

            const mensaje = document.getElementById("mensajeEstado");
            const boton = document.getElementById("btnConfirmarEstado");

            // Si el nuevo estado es 0, se va a desactivar el usuario
            if (nuevoEstado === 0) {

                mensaje.innerHTML = "¿Está seguro de que desea desactivar al usuario <strong>" +
                                    nombreUsuario +
                                    "</strong>? El usuario no podrá iniciar sesión mientras esté inactivo.";

                boton.className = "btn btn-danger";
                boton.textContent = "Desactivar";

            } else {

                // Si el nuevo estado es 1, se va a activar el usuario
                mensaje.innerHTML = "¿Está seguro de que desea activar al usuario <strong>" +
                                    nombreUsuario +
                                    "</strong>? El usuario podrá iniciar sesión nuevamente.";

                boton.className = "btn btn-success";
                boton.textContent = "Activar";
            }

            // Buscamos el modal y lo mostramos
            const modalElement = document.getElementById("modalEstado");
            const modal = bootstrap.Modal.getOrCreateInstance(modalElement);

            modal.show();
        }
    </script>

</body>
</html>
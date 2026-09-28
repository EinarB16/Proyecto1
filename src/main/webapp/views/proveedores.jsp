<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Proveedor" %>

<%!
    // Método auxiliar para evitar ataques XSS sin depender de librerías externas
    private String escaparHtml(String texto) {
        if (texto == null) return "";
        return texto.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proveedores - Conciliación Bancaria</title>

    <style>
        /* Configuración general de la página */
        body {
            background: #f3f5f7;
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
        }

        /* Barra superior del sistema */
        .barra-superior {
            background: #263445 !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
        }

        /* Nombre del sistema en la barra superior */
        .navbar-brand {
            font-weight: 600;
        }

        /* Contenedor principal de la página */
        .contenido-principal {
            width: calc(100% - 40px);
            max-width: 1380px;
            margin: 30px auto;
            padding-bottom: 30px;
        }

        /* Título principal */
        .titulo-pagina {
            color: #263445;
            font-weight: 600;
            margin-bottom: 4px;
        }

        /* Texto debajo del título */
        .subtitulo-pagina {
            color: #6c757d;
            margin-bottom: 0;
        }

        /* Botón principal para registrar proveedores */
        .btn-principal {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 16px;
        }

        /* Cambio de color al pasar el mouse */
        .btn-principal:hover {
            background: #345d86;
        }

        /* Tarjetas utilizadas en filtros y tabla */
        .tarjeta-filtros,
        .tarjeta-tabla {
            border: none;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        /* Encabezado de la sección de filtros */
        .cabecera-filtros {
            background: #263445;
            color: white;
            padding: 14px 20px;
        }

        /* Espaciado interno de los filtros */
        .cuerpo-filtros {
            padding: 22px;
        }

        /* Estilo de los campos de entrada y listas */
        .form-control,
        .form-select {
            border-radius: 8px;
            border: 1px solid #d9dee5;
        }

        /* Estilo de los campos cuando están seleccionados */
        .form-control:focus,
        .form-select:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82,109,138,0.15);
        }

        /* Botón para realizar la búsqueda */
        .boton-buscar {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 17px;
        }

        /* Cambio de color del botón buscar */
        .boton-buscar:hover {
            background: #345d86;
        }

        /* Botón para limpiar los filtros */
        .boton-limpiar {
            border-radius: 8px;
            padding: 9px 17px;
        }

        /* Encabezado de la tabla */
        .cabecera-tabla {
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            padding: 16px 20px;
        }

        /* Título de la tabla */
        .titulo-tabla {
            color: #263445;
            font-weight: 600;
            margin: 0;
        }

        /* Elimina el margen inferior de la tabla */
        .tabla-proveedores {
            margin-bottom: 0;
        }

        /* Encabezados de las columnas */
        .tabla-proveedores thead th {
            background: #eef1f5;
            color: #344054;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            border-bottom: 1px solid #dfe3e8;
        }

        /* Datos de las filas */
        .tabla-proveedores tbody td {
            font-size: 14px;
            vertical-align: middle;
        }

        /* Color de la fila cuando se pasa el mouse */
        .tabla-proveedores tbody tr:hover {
            background: #f8f9fa;
        }

        /* Estilo de las etiquetas de estado */
        .estado-badge {
            font-size: 12px;
            padding: 6px 9px;
            border-radius: 6px;
        }

        /* Espacio mínimo para la columna de acciones */
        .acciones {
            min-width: 175px;
            white-space: nowrap;
        }

        /* Estilo de los botones de acciones */
        .acciones .btn {
            border-radius: 7px;
            font-size: 12px;
            margin-right: 3px;
            margin-bottom: 3px;
        }

        /* Espaciado cuando no hay proveedores */
        .mensaje-vacio {
            padding: 35px !important;
        }

        /* Diseño general de los modales */
        .modal-content {
            border: none;
            border-radius: 14px;
            overflow: hidden;
        }

        /* Encabezado de los modales */
        .modal-header {
            background: #263445;
            color: white;
        }

        /* Hace visible el botón de cerrar sobre el fondo oscuro */
        .modal-header .btn-close {
            filter: invert(1);
        }

        /* Fondo del pie de los modales */
        .modal-footer {
            background: #f8f9fa;
        }

        /* Estilo del botón para regresar al dashboard */
        .boton-dashboard {
            border-radius: 8px;
        }

        /* Ajustes para pantallas pequeñas */
        @media (max-width: 768px) {
            .contenido-principal {
                width: calc(100% - 30px);
                margin: 20px auto;
            }

            /* Coloca el encabezado de la página en columna */
            .encabezado-pagina {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 15px;
            }

            /* Hace que el botón ocupe todo el ancho */
            .encabezado-pagina .btn {
                width: 100%;
            }

            /* Reduce el ancho mínimo de acciones */
            .acciones {
                min-width: 160px;
            }
        }
    </style>
</head>

<body>
    <!-- Menú principal del sistema -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Barra superior con el nombre del sistema y usuario conectado -->
    <nav class="navbar navbar-dark barra-superior">
        <div class="container-fluid px-4">
            <!-- Nombre del sistema -->
            <span class="navbar-brand">Conciliación Bancaria</span>

            <!-- Información del usuario y botón de cierre de sesión -->
            <div class="d-flex align-items-center">
                <span class="text-white me-3">
                    Bienvenido, <strong><%= session.getAttribute("nombreUsuario") %></strong>
                </span>

                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-light btn-sm">Cerrar sesión</a>
            </div>
        </div>
    </nav>

    <div class="container contenido-principal">
        <!-- Encabezado de la sección de proveedores -->
        <div class="d-flex justify-content-between align-items-center encabezado-pagina mb-4">
            <div>
                <h2 class="titulo-pagina">Proveedores</h2>
                <p class="subtitulo-pagina">Consulta y administración de los proveedores registrados.</p>
            </div>

            <!-- Botón para registrar un nuevo proveedor -->
            <a href="<%= request.getContextPath() %>/ProveedorServlet?accion=nuevo" class="btn btn-principal text-white">
                + Nuevo proveedor
            </a>
        </div>

        <!-- Muestra el mensaje de error enviado por el servlet -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= escaparHtml((String) request.getAttribute("error")) %>
            </div>
        <% } %>

        <!-- Sección de filtros de búsqueda -->
        <div class="card tarjeta-filtros mb-4">
            <div class="cabecera-filtros">
                <strong>Filtros de búsqueda</strong>
            </div>

            <div class="card-body cuerpo-filtros">
                <!-- Formulario que envía los filtros al ProveedorServlet -->
                <form method="get" action="<%= request.getContextPath() %>/ProveedorServlet">
                    <div class="row g-3">
                        <!-- Filtro por nombre -->
                        <div class="col-md-4">
                            <label for="nombre" class="form-label">Nombre</label>
                            <input type="text"
                                   id="nombre"
                                   name="nombre"
                                   autocomplete="off"
                                   class="form-control"
                                   placeholder="Nombre del proveedor"
                                   maxlength="15"
                                   oninput="this.value = this.value.replace(/[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ .,'\-]/g, '')"
                                   value="<%= request.getParameter("nombre") != null ? escaparHtml(request.getParameter("nombre")) : "" %>">
                        </div>

                        <!-- Filtro por RUC -->
                        <div class="col-md-4">
                            <label for="ruc" class="form-label">RUC</label>
                            <input type="text"
                                   id="ruc"
                                   name="ruc"
                                   autocomplete="off"
                                   class="form-control"
                                   placeholder="RUC del proveedor"
                                   maxlength="15"
                                   oninput="this.value = this.value.replace(/[^0-9\-]/g, '')"
                                   value="<%= request.getParameter("ruc") != null ? escaparHtml(request.getParameter("ruc")) : "" %>">
                        </div>

                        <!-- Filtro por estado -->
                        <div class="col-md-4">
                            <label for="estado" class="form-label">Estado</label>

                            <%
                                // Obtiene el estado seleccionado desde los parámetros de búsqueda
                                String estadoParam = request.getParameter("estado");
                            %>

                            <select id="estado" name="estado" class="form-select">
                                <option value="">Todos</option>
                                <option value="1" <%= "1".equals(estadoParam) ? "selected" : "" %>>Activo</option>
                                <option value="0" <%= "0".equals(estadoParam) ? "selected" : "" %>>Inactivo</option>
                            </select>
                        </div>
                    </div>

                    <!-- Botones para buscar o limpiar los filtros -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit" class="btn boton-buscar text-white">Buscar</button>
                        <a href="<%= request.getContextPath() %>/ProveedorServlet" class="btn btn-secondary boton-limpiar">Limpiar</a>
                    </div>
                </form>
            </div>
        </div>

        <%
            // Obtiene del servlet la lista de proveedores
            List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
        %>

        <!-- Tarjeta donde se muestran los proveedores -->
        <div class="card tarjeta-tabla">
            <div class="cabecera-tabla">
                <h5 class="titulo-tabla">Proveedores registrados</h5>
            </div>

            <div class="card-body p-0">
                <!-- Permite desplazar solamente la tabla en pantallas pequeñas -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle tabla-proveedores">
                        <thead>
                            <tr>
                                <th>RUC</th>
                                <th>Nombre</th>
                                <th>Teléfono</th>
                                <th>Correo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>
                        <%
                            // Verifica si existen proveedores para mostrar
                            if (proveedores != null && !proveedores.isEmpty()) {

                                // Recorre la lista de proveedores
                                for (Proveedor p : proveedores) {
                        %>
                            <tr>
                                <!-- RUC del proveedor -->
                                <td><%= p.getRuc() != null ? escaparHtml(p.getRuc()) : "" %></td>

                                <!-- Nombre del proveedor -->
                                <td><%= p.getNombre() != null ? escaparHtml(p.getNombre()) : "" %></td>

                                <!-- Teléfono del proveedor -->
                                <td><%= p.getTelefono() != null ? escaparHtml(p.getTelefono()) : "-" %></td>

                                <!-- Correo del proveedor -->
                                <td><%= p.getCorreo() != null ? escaparHtml(p.getCorreo()) : "-" %></td>

                                <!-- Estado actual del proveedor -->
                                <td>
                                    <% if (p.getEstado() == 1) { %>
                                        <!-- Estado activo -->
                                        <span class="badge bg-success estado-badge">Activo</span>
                                    <% } else { %>
                                        <!-- Estado inactivo -->
                                        <span class="badge bg-secondary estado-badge">Inactivo</span>
                                    <% } %>
                                </td>

                                <!-- Botones disponibles para cada proveedor -->
                                <td class="acciones">
                                    <!-- Enlace para editar el proveedor -->
                                    <a href="<%= request.getContextPath() %>/ProveedorServlet?accion=editar&idProveedor=<%= p.getIdProveedor() %>"
                                       class="btn btn-sm btn-outline-primary">Editar</a>

                                    <% if (p.getEstado() == 1) { %>
                                        <!-- Si está activo, se muestra la opción para desactivarlo -->
                                        <button type="button"
                                                class="btn btn-sm btn-outline-danger"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalDesactivar<%= p.getIdProveedor() %>">Desactivar</button>
                                    <% } else { %>
                                        <!-- Si está inactivo, se muestra la opción para activarlo -->
                                        <button type="button"
                                                class="btn btn-sm btn-outline-success"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalActivar<%= p.getIdProveedor() %>">Activar</button>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <!-- Mensaje mostrado cuando no existen proveedores -->
                            <tr>
                                <td colspan="6" class="text-center text-muted mensaje-vacio">
                                    No hay proveedores registrados.
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

    <%
        // Se recorren nuevamente los proveedores para generar los modales
        if (proveedores != null && !proveedores.isEmpty()) {

            // Recorre cada proveedor para crear su modal correspondiente
            for (Proveedor p : proveedores) {

                // Si el proveedor está activo, se genera el modal para desactivarlo
                if (p.getEstado() == 1) {
    %>
    <!-- Modal para confirmar la desactivación del proveedor -->
    <div class="modal fade"
         id="modalDesactivar<%= p.getIdProveedor() %>"
         tabindex="-1"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar desactivación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <p>¿Está seguro de que desea desactivar este proveedor?</p>
                    <p class="mb-0">
                        <strong><%= p.getNombre() != null ? escaparHtml(p.getNombre()) : "" %></strong>
                    </p>
                </div>

                <div class="modal-footer">
                    <!-- Botón para cerrar el modal sin realizar cambios -->
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                    <!-- Formulario que cambia el estado del proveedor a inactivo -->
                    <form action="<%= request.getContextPath() %>/ProveedorServlet" method="post">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="idProveedor" value="<%= p.getIdProveedor() %>">
                        <input type="hidden" name="nuevoEstado" value="0">
                        <button type="submit" class="btn btn-danger">Confirmar desactivación</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <% } else { %>

    <!-- Modal para confirmar la activación del proveedor -->
    <div class="modal fade"
         id="modalActivar<%= p.getIdProveedor() %>"
         tabindex="-1"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar activación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <p>¿Está seguro de que desea activar este proveedor?</p>
                    <p class="mb-0">
                        <strong><%= p.getNombre() != null ? escaparHtml(p.getNombre()) : "" %></strong>
                    </p>
                </div>

                <div class="modal-footer">
                    <!-- Botón para cerrar el modal sin realizar cambios -->
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                    <!-- Formulario que cambia el estado del proveedor a activo -->
                    <form action="<%= request.getContextPath() %>/ProveedorServlet" method="post">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="idProveedor" value="<%= p.getIdProveedor() %>">
                        <input type="hidden" name="nuevoEstado" value="1">
                        <button type="submit" class="btn btn-success">Confirmar activación</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%
                }
            }
        }
    %>

</body>
</html>
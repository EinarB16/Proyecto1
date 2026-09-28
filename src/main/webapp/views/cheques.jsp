<%@ page import="java.util.List" %>
<%@ page import="model.Cheque" %>
<%@ page import="model.Proveedor" %>

<%
    // Lista de cheques que viene desde el servlet
    List<Cheque> cheques = (List<Cheque>) request.getAttribute("cheques");

    // Lista de proveedores para el filtro
    List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");

    // Datos de los filtros usados en la búsqueda
    //
    // IMPORTANTE (fix):
    // El servlet y el DAO leen "fechaInicio" / "fechaFin",
    // no "fechaDesde" / "fechaHasta". Antes el formulario mandaba
    // fechaDesde/fechaHasta y el servlet nunca los recibía, por lo
    // que el filtro de fechas no hacía nada.
    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");
    String numeroCheque = request.getParameter("numeroCheque");
    String idProveedor = request.getParameter("idProveedor");
    String estado = request.getParameter("estado");

    // Mensaje de error enviado desde el servlet
    String mensajeError = (String) request.getAttribute("mensajeError");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheques</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* Fondo general de la página */
        body {
            background: #f3f5f7;
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
        }

        /* Barra superior */
        .barra-superior {
            background: #263445 !important;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
        }

        .navbar-brand {
            font-weight: 600;
        }

        /* Contenedor principal */
        .contenido-principal {
            width: calc(100% - 40px);
            max-width: 1450px;
            margin: 30px auto;
            padding-bottom: 30px;
        }

        /* Título de la página */
        .titulo-pagina {
            color: #263445;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .subtitulo-pagina {
            color: #6c757d;
            margin-bottom: 0;
        }

        /* Botón principal */
        .btn-principal {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 16px;
        }

        .btn-principal:hover {
            background: #345d86;
        }

        /* Tarjetas de los filtros y la tabla */
        .tarjeta-filtros,
        .tarjeta-tabla {
            border: none;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
            overflow: hidden;
        }

        /* Encabezado de los filtros */
        .cabecera-filtros {
            background: #263445;
            color: white;
            padding: 14px 20px;
        }

        .cuerpo-filtros {
            padding: 22px;
        }

        /* Campos del formulario */
        .form-control,
        .form-select {
            border-radius: 8px;
            border: 1px solid #d9dee5;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.15rem rgba(82, 109, 138, 0.15);
        }

        /* Botones de búsqueda */
        .boton-buscar {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
        }

        .boton-buscar:hover {
            background: #345d86;
        }

        .boton-limpiar {
            border-radius: 8px;
        }

        /* Encabezado de la tabla */
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

        /* Tabla */
        .tabla-cheques {
            margin-bottom: 0;
        }

        .tabla-cheques thead th {
            background: #eef1f5;
            color: #344054;
            font-size: 13px;
            font-weight: 600;
            border-bottom: 1px solid #dfe3e8;
            white-space: nowrap;
        }

        .tabla-cheques tbody td {
            font-size: 14px;
            vertical-align: middle;
        }

        .tabla-cheques tbody tr:hover {
            background: #f8f9fa;
        }

        /* Estados de los cheques */
        .estado-badge {
            font-size: 12px;
            padding: 6px 9px;
            border-radius: 6px;
        }

        /* Botones de acciones */
        .acciones {
            min-width: 180px;
            white-space: nowrap;
        }

        .acciones .btn {
            border-radius: 7px;
            font-size: 12px;
        }

        /* Cuando no hay cheques */
        .mensaje-vacio {
            padding: 35px !important;
        }

        /* Ventanas de confirmación */
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

        /* Botón para volver al dashboard */
        .boton-dashboard {
            border-radius: 8px;
        }

        /* Ajustes para pantallas pequeñas */
        @media (max-width: 768px) {
            .contenido-principal {
                width: calc(100% - 30px);
                margin: 20px auto;
            }

            .cabecera-tabla {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .acciones {
                min-width: 160px;
            }
        }
    </style>
</head>

<body>

    <!-- Incluye el menú lateral/superior del sistema -->
    <jsp:include page="../includes/menu.jsp" />

    <!-- Barra superior -->
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

    <main class="contenido-principal">

        <!-- Encabezado de la página -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="titulo-pagina">Cheques</h2>
                <p class="subtitulo-pagina">Consulta y administración de los cheques registrados.</p>
            </div>

            <!-- Botón para registrar un nuevo cheque -->
            <a href="<%= request.getContextPath() %>/ChequeServlet?accion=nuevo" class="btn btn-principal text-white">
                Registrar cheque
            </a>
        </div>

        <!-- Mensaje de error -->
        <% if (mensajeError != null && !mensajeError.isEmpty()) { %>
            <div class="alert alert-danger">
                <%= mensajeError %>
            </div>
        <% } %>

        <!-- Filtros de búsqueda -->
        <div class="card tarjeta-filtros mb-4">
            <div class="cabecera-filtros">
                <h5 class="mb-0">Buscar cheques</h5>
            </div>

            <div class="cuerpo-filtros">
                <form action="<%= request.getContextPath() %>/ChequeServlet" method="get">

                    <!-- Indica al servlet que se realizará una búsqueda -->
                    <input type="hidden" name="accion" value="buscar">

                    <div class="row g-3">

                        <!-- Fecha inicial -->
                        <div class="col-md-3">
                            <label for="fechaDesde" class="form-label">Fecha desde</label>
                            <input type="date"
                                   class="form-control"
                                   id="fechaDesde"
                                   name="fechaInicio"
                                   value="<%= fechaInicio != null ? fechaInicio : "" %>">
                        </div>

                        <!-- Fecha final -->
                        <div class="col-md-3">
                            <label for="fechaHasta" class="form-label">Fecha hasta</label>
                            <input type="date"
                                   class="form-control"
                                   id="fechaHasta"
                                   name="fechaFin"
                                   value="<%= fechaFin != null ? fechaFin : "" %>">
                        </div>

                        <!-- Número del cheque -->
                       <div class="col-md-2">
					    <label for="numeroCheque" class="form-label">N.º cheque</label>
					    <input type="text"
					           class="form-control"
					           autocomplete="off"
					           id="numeroCheque"
					           name="numeroCheque"
					           maxlength="4"
					           inputmode="numeric"
					           pattern="^[1-9][0-9]*$"
					           title="Solo se permiten números (máximo 4 dígitos) y no puede empezar con 0"
					           oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/^0+/, '')"
					           value="<%= numeroCheque != null ? numeroCheque : "" %>">
						</div>
                        <!-- Proveedor -->
                        <div class="col-md-2">
                            <label for="idProveedor" class="form-label">Proveedor</label>
                            <select class="form-select" id="idProveedor" name="idProveedor">
                                <option value="">Todos</option>

                                <% if (proveedores != null) {
                                    // Mostramos los proveedores disponibles en el filtro
                                    for (Proveedor proveedor : proveedores) { %>

                                        <option value="<%= proveedor.getIdProveedor() %>"
                                            <%= String.valueOf(proveedor.getIdProveedor()).equals(idProveedor) ? "selected" : "" %>>
                                            <%= proveedor.getNombre() %>
                                        </option>

                                <%  }
                                } %>
                            </select>
                        </div>

                        <!-- Estado -->
                        <div class="col-md-2">
                            <label for="estado" class="form-label">Estado</label>
                            <select class="form-select" id="estado" name="estado">
                                <option value="">Todos</option>
                                <option value="1" <%= "1".equals(estado) ? "selected" : "" %>>Emitido</option>
                                <option value="2" <%= "2".equals(estado) ? "selected" : "" %>>Pendiente</option>
                                <option value="3" <%= "3".equals(estado) ? "selected" : "" %>>Cobrado</option>
                                <option value="4" <%= "4".equals(estado) ? "selected" : "" %>>Anulado</option>
                                <option value="5" <%= "5".equals(estado) ? "selected" : "" %>>Fuera de circulación</option>
                            </select>
                        </div>

                        <!-- Botones para realizar o limpiar la búsqueda -->
                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn boton-buscar text-white">
                                Buscar
                            </button>

                            <a href="<%= request.getContextPath() %>/ChequeServlet?accion=listar"
                               class="btn btn-outline-secondary boton-limpiar">
                                Limpiar
                            </a>
                        </div>

                    </div>
                </form>
            </div>
        </div>

        <!-- Tabla de cheques -->
        <div class="card tarjeta-tabla">

            <div class="cabecera-tabla d-flex justify-content-between align-items-center">
                <h5 class="titulo-tabla">Listado de cheques</h5>
                <span class="text-muted small">
                    Total: <%= cheques != null ? cheques.size() : 0 %>
                </span>
            </div>

            <div class="table-responsive">
                <table class="table tabla-cheques">
                    <thead>
                        <tr>
                            <th>N.º cheque</th>
                            <th>Fecha</th>
                            <th>Proveedor</th>
                            <th>Monto</th>
                            <th>Detalle</th>
                            <th>Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (cheques != null && !cheques.isEmpty()) {

                            // Recorremos la lista para mostrar cada cheque
                            for (Cheque cheque : cheques) { %>

                                <tr>
                                    <td>
                                        <%= cheque.getNumeroCheque() %>
                                    </td>

                                    <td>
                                        <%= cheque.getFechaCheque() %>
                                    </td>

                                    <td>
                                        <%= cheque.getNombreProveedor() %>
                                    </td>

                                    <td>
                                        $<%= cheque.getMonto() %>
                                    </td>

                                    <td>
                                        <%= cheque.getDetalle() %>
                                    </td>

                                    <td>
                                        <% 
                                            // Dependiendo del estado mostramos un texto diferente
                                            String textoEstado = "";
                                            String claseEstado = "";

                                            switch (cheque.getEstado()) {
                                                case 1:
                                                    textoEstado = "Emitido";
                                                    claseEstado = "bg-primary";
                                                    break;

                                                case 2:
                                                    textoEstado = "Pendiente";
                                                    claseEstado = "bg-warning text-dark";
                                                    break;

                                                case 3:
                                                    textoEstado = "Cobrado";
                                                    claseEstado = "bg-success";
                                                    break;

                                                case 4:
                                                    textoEstado = "Anulado";
                                                    claseEstado = "bg-danger";
                                                    break;

                                                case 5:
                                                    textoEstado = "Fuera de circulación";
                                                    claseEstado = "bg-secondary";
                                                    break;

                                                default:
                                                    textoEstado = "Desconocido";
                                                    claseEstado = "bg-dark";
                                                    break;
                                            }
                                        %>

                                        <span class="badge estado-badge <%= claseEstado %>">
                                            <%= textoEstado %>
                                        </span>
                                    </td>

                                    <td class="acciones text-center">

                                        <!-- Acciones disponibles según el estado del cheque -->

                                        <% if (cheque.getEstado() == 1) { %>

                                            <!-- Un cheque emitido puede pasar a pendiente o ser anulado -->
                                            <button type="button"
                                                    class="btn btn-warning btn-sm"
                                                    onclick="abrirModalPendiente(<%= cheque.getIdCheque() %>)">
                                                Pendiente
                                            </button>

                                            <button type="button"
                                                    class="btn btn-danger btn-sm"
                                                    onclick="abrirModalAnular(<%= cheque.getIdCheque() %>)">
                                                Anular
                                            </button>

                                        <% } else if (cheque.getEstado() == 2) { %>

                                            <!-- Un cheque pendiente puede cobrarse, salir de circulación o anularse -->
                                            <button type="button"
                                                    class="btn btn-success btn-sm"
                                                    onclick="abrirModalCobrado(<%= cheque.getIdCheque() %>)">
                                                Cobrado
                                            </button>

                                            <button type="button"
                                                    class="btn btn-secondary btn-sm"
                                                    onclick="abrirModalFueraCirculacion(<%= cheque.getIdCheque() %>)">
                                                Fuera circulación
                                            </button>

                                            <button type="button"
                                                    class="btn btn-danger btn-sm"
                                                    onclick="abrirModalAnular(<%= cheque.getIdCheque() %>)">
                                                Anular
                                            </button>

                                        <% } %>

                                    </td>
                                </tr>

                        <%  }
                        } else { %>

                            <!-- Mensaje cuando no existen resultados -->
                            <tr>
                                <td colspan="7" class="text-center text-muted mensaje-vacio">
                                    No hay cheques para mostrar.
                                </td>
                            </tr>

                        <% } %>

                    </tbody>
                </table>
            </div>
        </div>

        <!-- Botón para volver al dashboard -->
        <div class="mt-4">
            <a href="<%= request.getContextPath() %>/DashboardServlet"
               class="btn btn-outline-secondary boton-dashboard">
                Volver al dashboard
            </a>
        </div>

    </main>

    <!-- =====================================================
         MODALES PARA CAMBIAR EL ESTADO DE LOS CHEQUES
         ===================================================== -->

    <!-- Modal para anular un cheque -->
    <div class="modal fade" id="modalAnular" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Anular cheque</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    ¿Está seguro de que desea anular este cheque?
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>

                    <form action="<%= request.getContextPath() %>/ChequeServlet" method="post">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="idCheque" id="idChequeAnular">
                        <input type="hidden" name="nuevoEstado" value="4">

                        <button type="submit" class="btn btn-danger">
                            Anular
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal para sacar de circulación -->
    <div class="modal fade" id="modalFueraCirculacion" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Sacar de circulación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    ¿Está seguro de que desea sacar este cheque de circulación?
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>

                    <form action="<%= request.getContextPath() %>/ChequeServlet" method="post">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="idCheque" id="idChequeFueraCirculacion">
                        <input type="hidden" name="nuevoEstado" value="5">

                        <button type="submit" class="btn btn-secondary">
                            Confirmar
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal para marcar como pendiente -->
    <div class="modal fade" id="modalPendiente" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Marcar como pendiente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    ¿Está seguro de que desea marcar este cheque como pendiente?
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>

                    <form action="<%= request.getContextPath() %>/ChequeServlet" method="post">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="idCheque" id="idChequePendiente">
                        <input type="hidden" name="nuevoEstado" value="2">

                        <button type="submit" class="btn btn-warning">
                            Confirmar
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal para marcar como cobrado -->
    <div class="modal fade" id="modalCobrado" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Marcar como cobrado</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    ¿Está seguro de que desea marcar este cheque como cobrado?
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>

                    <form action="<%= request.getContextPath() %>/ChequeServlet" method="post">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="idCheque" id="idChequeCobrado">
                        <input type="hidden" name="nuevoEstado" value="3">

                        <button type="submit" class="btn btn-success">
                            Confirmar
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Bootstrap para que funcionen los modales -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Abre el modal para anular un cheque
        function abrirModalAnular(idCheque) {
            document.getElementById("idChequeAnular").value = idCheque;

            const modal = new bootstrap.Modal(
                document.getElementById("modalAnular")
            );

            modal.show();
        }

        // Abre el modal para sacar un cheque de circulación
        function abrirModalFueraCirculacion(idCheque) {
            document.getElementById("idChequeFueraCirculacion").value = idCheque;

            const modal = new bootstrap.Modal(
                document.getElementById("modalFueraCirculacion")
            );

            modal.show();
        }

        // Abre el modal para marcar un cheque como pendiente
        function abrirModalPendiente(idCheque) {
            document.getElementById("idChequePendiente").value = idCheque;

            const modal = new bootstrap.Modal(
                document.getElementById("modalPendiente")
            );

            modal.show();
        }

        // Abre el modal para marcar un cheque como cobrado
        function abrirModalCobrado(idCheque) {
            document.getElementById("idChequeCobrado").value = idCheque;

            const modal = new bootstrap.Modal(
                document.getElementById("modalCobrado")
            );

            modal.show();
        }
    </script>

</body>
</html>
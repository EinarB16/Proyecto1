<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Deposito" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <!-- Bootstrap para el diseño y los componentes de la página -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Configuración básica de la página -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Depósitos - Conciliación Bancaria</title>

    <style>
        /* Fondo general de la página */
        body {
            background: #f3f5f7;
        }

        /* Barra superior del sistema */
        .barra-superior {
            background: #263445 !important;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
        }

        /* Nombre del sistema en la barra superior */
        .navbar-brand {
            font-weight: 600;
        }

        /* Contenedor principal de la página */
        .contenido-principal {
            max-width: 1450px;
            width: calc(100% - 30px);
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

        /* Botón principal para registrar depósitos */
        .btn-principal {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 16px;
        }

        /* Cambio de color al pasar el cursor */
        .btn-principal:hover {
            background: #345d86;
        }

        /* Tarjeta que contiene los filtros */
        .tarjeta-filtros {
            border: none;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
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

        /* Bordes redondeados de los campos */
        .form-control,
        .form-select {
            border-radius: 8px;
        }

        /* Estilo de los campos cuando están seleccionados */
        .form-control:focus,
        .form-select:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82, 109, 138, 0.15);
        }

        /* Botón para realizar la búsqueda */
        .boton-buscar {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
        }

        /* Cambio de color del botón de búsqueda */
        .boton-buscar:hover {
            background: #345d86;
        }

        /* Botón para limpiar los filtros */
        .boton-limpiar {
            border-radius: 8px;
        }

        /* Tarjeta donde se muestra la tabla */
        .tarjeta-tabla {
            border: none;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
            overflow: hidden;
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
        .tabla-depositos {
            margin-bottom: 0;
        }

        /* Encabezados de las columnas */
        .tabla-depositos thead th {
            background: #eef1f5;
            color: #344054;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            border-bottom: 1px solid #dfe3e8;
        }

        /* Contenido de las filas */
        .tabla-depositos tbody td {
            font-size: 14px;
            vertical-align: middle;
        }

        /* Efecto al pasar el cursor sobre una fila */
        .tabla-depositos tbody tr:hover {
            background: #f8f9fa;
        }

        /* Estilo de las etiquetas de estado */
        .estado-badge {
            font-size: 12px;
            padding: 6px 9px;
            border-radius: 6px;
            white-space: nowrap;
        }

        /* Espacio mínimo para las acciones */
        .acciones {
            min-width: 130px;
        }

        /* Tamaño de los botones de acciones */
        .acciones .btn {
            border-radius: 7px;
            font-size: 12px;
        }

        /* Espacio para el mensaje cuando no hay registros */
        .mensaje-vacio {
            padding: 35px !important;
        }

        /* Diseño general de las ventanas modales */
        .modal-content {
            border: none;
            border-radius: 14px;
            overflow: hidden;
        }

        /* Color del texto de los encabezados de los modales */
        .modal-header {
            color: white;
        }

        /* Fondo del pie de los modales */
        .modal-footer {
            background: #f8f9fa;
        }

        /* Estilo del botón para regresar al Dashboard */
        .boton-dashboard {
            border-radius: 8px;
        }

        /* Ajustes para pantallas pequeñas */
        @media (max-width: 768px) {
            .contenido-principal {
                width: 100%;
                margin: 20px auto;
                padding-left: 15px;
                padding-right: 15px;
            }

            /* El encabezado cambia a una distribución vertical */
            .encabezado-pagina {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 15px;
            }

            /* El botón ocupa todo el ancho disponible */
            .encabezado-pagina .btn {
                width: 100%;
            }

            .acciones {
                min-width: 130px;
            }
        }
    </style>
</head>
<body>

    <!-- Menú lateral o navegación principal del sistema -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Barra superior con el nombre del sistema y usuario conectado -->
    <nav class="navbar navbar-dark barra-superior">
        <div class="container">
            <span class="navbar-brand">Conciliación Bancaria</span>
            <div class="d-flex align-items-center">
                <span class="text-white me-3">
                    Bienvenido, <strong><%= session.getAttribute("nombreUsuario") %></strong>
                </span>
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-light btn-sm">Cerrar sesión</a>
            </div>
        </div>
    </nav>

    <!-- Contenido principal de la página -->
    <div class="container contenido-principal">

        <!-- Encabezado de la sección de depósitos -->
        <div class="d-flex justify-content-between align-items-center encabezado-pagina mb-4">
            <div>
                <h2 class="titulo-pagina">Depósitos</h2>
                <p class="subtitulo-pagina">Consulta y administración de los depósitos registrados.</p>
            </div>

            <!-- Botón para abrir el formulario de registro -->
            <a href="<%= request.getContextPath() %>/DepositoServlet?accion=nuevo" class="btn btn-principal text-white">
                Registrar depósito
            </a>
        </div>

        <!-- Sección para buscar y filtrar depósitos -->
        <div class="card tarjeta-filtros mb-4">

            <!-- Encabezado de los filtros -->
            <div class="cabecera-filtros">
                <strong>Buscar depósitos</strong>
            </div>

            <!-- Campos de búsqueda -->
            <div class="card-body cuerpo-filtros">
                <form method="get" action="<%= request.getContextPath() %>/DepositoServlet">

                    <div class="row g-3">

                        <!-- Filtro por fecha inicial -->
                        <div class="col-md-3">
                            <label class="form-label">Fecha desde</label>
                            <input type="date" name="fechaInicio" class="form-control">
                        </div>

                        <!-- Filtro por fecha final -->
                        <div class="col-md-3">
                            <label class="form-label">Fecha hasta</label>
                            <input type="date" name="fechaFin" class="form-control">
                        </div>

                        <!-- Filtro por número de comprobante -->
                        <div class="col-md-3">
                            <label class="form-label">Número de comprobante</label>
                            <input type="number" name="numeroComprobante" class="form-control"
                                   min="1" max="9999"
                                   onkeydown="return !['e', 'E', '+', '-', '.'].includes(event.key);"
                                   oninput="this.value = this.value.replace(/^0+/, '').slice(0, 4);">
                        </div>

                        <!-- Filtro por tipo de depósito -->
                        <div class="col-md-3">
                            <label class="form-label">Tipo de depósito</label>
                            <select name="tipoDeposito" class="form-select">
                                <option value="">Todos</option>
                                <option value="1">Transferencia</option>
                                <option value="2">Depósito directo</option>
                            </select>
                        </div>
                    </div>

                    <!-- Botones para ejecutar o limpiar la búsqueda -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit" class="btn boton-buscar text-white">Buscar</button>
                        <a href="<%= request.getContextPath() %>/DepositoServlet" class="btn btn-secondary boton-limpiar">
                            Limpiar
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tarjeta que contiene la lista de depósitos -->
        <div class="card tarjeta-tabla">

            <!-- Título de la tabla -->
            <div class="cabecera-tabla">
                <h5 class="titulo-tabla">Depósitos registrados</h5>
            </div>

            <div class="card-body p-0">

                <!-- Permite desplazar solamente la tabla en pantallas pequeñas -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle tabla-depositos">
                        <thead>
                            <tr>
                                <th>Comprobante</th>
                                <th>Fecha</th>
                                <th>Tipo</th>
                                <th>Monto</th>
                                <th>Detalle</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                // Obtiene la lista de depósitos enviada por el servlet
                                List<Deposito> listaDepositos = (List<Deposito>) request.getAttribute("listaDepositos");

                                // Verifica si existen depósitos para mostrar
                                if (listaDepositos != null && !listaDepositos.isEmpty()) {

                                    // Recorre cada depósito de la lista
                                    for (Deposito deposito : listaDepositos) {
                            %>
                                <tr>

                                    <!-- Número de comprobante -->
                                    <td><%= deposito.getNumeroComprobante() %></td>

                                    <!-- Fecha del depósito -->
                                    <td><%= deposito.getFecha() %></td>

                                    <!-- Tipo de depósito -->
                                    <td>
                                        <%
                                            // El tipo 1 corresponde a una transferencia
                                            if (deposito.getTipoDeposito() == 1) {
                                        %>
                                            Transferencia
                                        <%
                                            // El tipo 2 corresponde a un depósito directo
                                            } else if (deposito.getTipoDeposito() == 2) {
                                        %>
                                            Depósito directo
                                        <%
                                            // Se muestra este texto si el tipo no coincide con los valores conocidos
                                            } else {
                                        %>
                                            Desconocido
                                        <%
                                            }
                                        %>
                                    </td>

                                    <!-- Monto del depósito -->
                                    <td>B/. <%= String.format("%.2f", deposito.getMonto()) %></td>

                                    <!-- Detalle del depósito -->
                                    <td><%= deposito.getDetalle() != null ? deposito.getDetalle() : "" %></td>

                                    <!-- Estado actual del depósito -->
                                    <td>
                                        <%
                                            // Estado 1 significa que el depósito está activo
                                            if (deposito.getEstado() == 1) {
                                        %>
                                            <span class="badge bg-success estado-badge">Activo</span>
                                        <%
                                            // Cualquier otro estado se muestra como inactivo
                                            } else {
                                        %>
                                            <span class="badge bg-secondary estado-badge">Inactivo</span>
                                        <%
                                            }
                                        %>
                                    </td>

                                    <!-- Acciones disponibles según el estado -->
                                    <td class="acciones">
                                        <% if (deposito.getEstado() == 1) { %>

                                            <!-- Si está activo, se permite desactivarlo -->
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-danger"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalDesactivar<%= deposito.getIdDeposito() %>">
                                                Desactivar
                                            </button>

                                        <% } else { %>

                                            <!-- Si está inactivo, se permite activarlo -->
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-success"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalActivar<%= deposito.getIdDeposito() %>">
                                                Activar
                                            </button>

                                        <% } %>
                                    </td>
                                </tr>

                            <%
                                    }
                                } else {
                            %>

                                <!-- Mensaje mostrado cuando no existen depósitos -->
                                <tr>
                                    <td colspan="7" class="text-center text-muted mensaje-vacio">
                                        No hay depósitos registrados.
                                    </td>
                                </tr>

                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <%
                    // Genera los modales de activación y desactivación para cada depósito
                    if (listaDepositos != null && !listaDepositos.isEmpty()) {
                        for (Deposito deposito : listaDepositos) {
                %>

                    <% if (deposito.getEstado() == 1) { %>

                        <!-- Modal para confirmar la desactivación -->
                        <div class="modal fade"
                             id="modalDesactivar<%= deposito.getIdDeposito() %>"
                             tabindex="-1"
                             aria-hidden="true">

                            <div class="modal-dialog">
                                <div class="modal-content">

                                    <!-- Encabezado del modal -->
                                    <div class="modal-header bg-danger text-white">
                                        <h5 class="modal-title">Confirmar desactivación</h5>
                                        <button type="button"
                                                class="btn-close btn-close-white"
                                                data-bs-dismiss="modal"></button>
                                    </div>

                                    <!-- Información del depósito -->
                                    <div class="modal-body">
                                        <p>¿Está seguro de que desea desactivar este depósito?</p>

                                        <p class="mb-0">
                                            <strong>Comprobante:</strong>
                                            <%= deposito.getNumeroComprobante() %>
                                        </p>

                                        <p class="mb-0">
                                            <strong>Monto:</strong>
                                            B/. <%= String.format("%.2f", deposito.getMonto()) %>
                                        </p>

                                        <div class="alert alert-warning mt-3 mb-0">
                                            El depósito quedará como inactivo.
                                        </div>
                                    </div>

                                    <!-- Botones del modal -->
                                    <div class="modal-footer">
                                        <button type="button"
                                                class="btn btn-secondary"
                                                data-bs-dismiss="modal">
                                            Cancelar
                                        </button>

                                        <!-- Envía la solicitud para cambiar el estado -->
                                        <form action="<%= request.getContextPath() %>/DepositoServlet" method="post">
                                            <input type="hidden" name="accion" value="cambiarEstado">
                                            <input type="hidden" name="idDeposito" value="<%= deposito.getIdDeposito() %>">
                                            <input type="hidden" name="nuevoEstado" value="0">

                                            <button type="submit" class="btn btn-danger">
                                                Sí, desactivar
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                    <% } else { %>

                        <!-- Modal para confirmar la activación -->
                        <div class="modal fade"
                             id="modalActivar<%= deposito.getIdDeposito() %>"
                             tabindex="-1"
                             aria-hidden="true">

                            <div class="modal-dialog">
                                <div class="modal-content">

                                    <!-- Encabezado del modal -->
                                    <div class="modal-header bg-success text-white">
                                        <h5 class="modal-title">Confirmar activación</h5>
                                        <button type="button"
                                                class="btn-close btn-close-white"
                                                data-bs-dismiss="modal"></button>
                                    </div>

                                    <!-- Información del depósito -->
                                    <div class="modal-body">
                                        <p>¿Está seguro de que desea activar este depósito?</p>

                                        <p class="mb-0">
                                            <strong>Comprobante:</strong>
                                            <%= deposito.getNumeroComprobante() %>
                                        </p>

                                        <p class="mb-0">
                                            <strong>Monto:</strong>
                                            B/. <%= String.format("%.2f", deposito.getMonto()) %>
                                        </p>

                                        <div class="alert alert-info mt-3 mb-0">
                                            El depósito volverá a estar activo.
                                        </div>
                                    </div>

                                    <!-- Botones del modal -->
                                    <div class="modal-footer">
                                        <button type="button"
                                                class="btn btn-secondary"
                                                data-bs-dismiss="modal">
                                            Cancelar
                                        </button>

                                        <!-- Envía la solicitud para cambiar el estado -->
                                        <form action="<%= request.getContextPath() %>/DepositoServlet" method="post">
                                            <input type="hidden" name="accion" value="cambiarEstado">
                                            <input type="hidden" name="idDeposito" value="<%= deposito.getIdDeposito() %>">
                                            <input type="hidden" name="nuevoEstado" value="1">

                                            <button type="submit" class="btn btn-success">
                                                Sí, activar
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                    <% } %>

                <%
                        }
                    }
                %>

            </div>
        </div>

        <!-- Botón para regresar al Dashboard -->
        <div class="mt-3">
            <a href="<%= request.getContextPath() %>/DashboardServlet"
               class="btn btn-secondary boton-dashboard">
                Volver al Dashboard
            </a>
        </div>

    </div>
</body>
</html>
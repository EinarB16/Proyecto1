<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Proveedor"%>
<%@ page import="model.Cheque"%>
<%@ page import="model.Deposito"%>
<%@ page import="model.Conciliacion"%>

<%!
// Convierte algunos caracteres para mostrarlos de forma segura
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Consultas y Reportes</title>
</head>

<body class="bg-light">

    <!-- Incluye el menú del sistema -->
    <%@ include file="../includes/menu.jsp" %>

    <%
        // Datos que devuelve el servlet para mostrar los resultados
        String modalActivo = (String) request.getAttribute("modalActivo");
        String mensajeError = (String) request.getAttribute("error");
        List<Proveedor> proveedoresActivos = (List<Proveedor>) request.getAttribute("proveedoresActivos");
        List<Cheque> cheques = (List<Cheque>) request.getAttribute("cheques");
        List<Deposito> depositos = (List<Deposito>) request.getAttribute("depositos");
        List<Conciliacion> conciliaciones = (List<Conciliacion>) request.getAttribute("conciliaciones");
    %>

    <!-- Encabezado de la página -->
    <div class="container py-4">
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body py-4 px-4">
                <h2 class="fw-bold mb-2">Consultas y Reportes</h2>
                <p class="text-muted mb-0">Consulte la información registrada en el sistema.</p>
            </div>
        </div>

        <!-- Mensaje de error -->
        <% if (mensajeError != null && !mensajeError.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error:</strong> <%= escaparHtml(mensajeError) %>

                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Opciones de consultas -->
        <div class="row g-4 justify-content-center">

            <!-- Consulta de cheques -->
            <div class="col-lg-4 col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body text-center p-4">

                        <div class="mb-3">
                            <i class="bi bi-search" style="font-size: 2.5rem;"></i>
                        </div>

                        <h5 class="card-title fw-bold">Consulta de Cheques</h5>
                        <p class="card-text text-muted">
                            Consulte los cheques utilizando diferentes criterios de búsqueda.
                        </p>

                        <!-- Abre el formulario de búsqueda de cheques -->
                        <button type="button"
                                class="btn btn-primary"
                                data-bs-toggle="modal"
                                data-bs-target="#modalCheques">
                            <i class="bi bi-search me-1"></i>Consultar Cheques
                        </button>

                    </div>
                </div>
            </div>

            <!-- Consulta de depósitos -->
            <div class="col-lg-4 col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body text-center p-4">

                        <div class="mb-3">
                            <i class="bi bi-cash-stack" style="font-size: 2.5rem;"></i>
                        </div>

                        <h5 class="card-title fw-bold">Consulta de Depósitos</h5>
                        <p class="card-text text-muted">
                            Consulte los depósitos registrados en el sistema.
                        </p>

                        <!-- Abre el formulario de búsqueda de depósitos -->
                        <button type="button"
                                class="btn btn-success"
                                data-bs-toggle="modal"
                                data-bs-target="#modalDepositos">
                            <i class="bi bi-cash-stack me-1"></i>Consultar Depósitos
                        </button>

                    </div>
                </div>
            </div>

            <!-- Consulta de conciliaciones -->
            <div class="col-lg-4 col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body text-center p-4">

                        <div class="mb-3">
                            <i class="bi bi-bank" style="font-size: 2.5rem;"></i>
                        </div>

                        <h5 class="card-title fw-bold">Consulta de Conciliaciones</h5>
                        <p class="card-text text-muted">
                            Consulte las conciliaciones bancarias registradas.
                        </p>

                        <!-- Abre el formulario de búsqueda de conciliaciones -->
                        <button type="button"
                                class="btn btn-dark"
                                data-bs-toggle="modal"
                                data-bs-target="#modalConciliaciones">
                            <i class="bi bi-bank me-1"></i>Consultar Conciliaciones
                        </button>

                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal para consultar cheques -->
    <div class="modal fade" id="modalCheques" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="bi bi-search me-2"></i>Consulta de Cheques
                    </h5>

                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <!-- Formulario para buscar cheques -->
                    <form method="GET" action="<%= request.getContextPath() %>/ReporteServlet">

                        <!-- Indica al servlet que se está consultando cheques -->
                        <input type="hidden" name="tipo" value="cheques">

                        <div class="row g-3">

                            <!-- Fecha inicial -->
                            <div class="col-md-2">
                                <label class="form-label">Fecha inicial</label>
                                <input type="date"
                                       name="fechaInicial"
                                       class="form-control"
                                       value="<%= request.getParameter("fechaInicial") != null ? escaparHtml(request.getParameter("fechaInicial")) : "" %>">
                            </div>

                            <!-- Fecha final -->
                            <div class="col-md-2">
                                <label class="form-label">Fecha final</label>
                                <input type="date"
                                       name="fechaFinal"
                                       class="form-control"
                                       value="<%= request.getParameter("fechaFinal") != null ? escaparHtml(request.getParameter("fechaFinal")) : "" %>">
                            </div>

                            <!-- Número del cheque -->
                            <div class="col-md-2">
						    <label class="form-label">Número de cheque</label>
						    <input type="text"
						           name="numeroCheque"
						           class="form-control"
						           autocomplete="off"
						           placeholder="Número"
						           maxlength="4"
						           inputmode="numeric"
						           pattern="^[1-9][0-9]*$"
						           title="Solo se permiten números (máximo 4 dígitos) y no puede empezar con 0"
						           oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/^0+/, '')"
						           value="<%= request.getParameter("numeroCheque") != null ? escaparHtml(request.getParameter("numeroCheque")) : "" %>">
							</div>
                            <!-- Proveedor -->
                            <div class="col-md-3">
                                <label class="form-label">Proveedor</label>

                                <select name="proveedor" class="form-select">
                                    <option value="">Todos los proveedores</option>

                                    <%
                                        // Revisamos qué proveedor se seleccionó
                                        String proveedorSeleccionado = request.getParameter("proveedor");

                                        // Mostramos los proveedores activos en el selector
                                        if (proveedoresActivos != null) {
                                            for (Proveedor proveedor : proveedoresActivos) {
                                    %>

                                    <option value="<%= proveedor.getIdProveedor() %>"
                                        <%= String.valueOf(proveedor.getIdProveedor()).equals(proveedorSeleccionado) ? "selected" : "" %>>
                                        <%= escaparHtml(proveedor.getNombre()) %>
                                    </option>

                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <!-- Estado del cheque -->
                            <div class="col-md-2">
                                <label class="form-label">Estado</label>

                                <select name="estado" class="form-select">
                                    <option value="">Todos</option>
                                    <option value="1" <%= "1".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Emitido
                                    </option>
                                    <option value="2" <%= "2".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Pendiente
                                    </option>
                                    <option value="3" <%= "3".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Cobrado
                                    </option>
                                    <option value="4" <%= "4".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Anulado
                                    </option>
                                    <option value="5" <%= "5".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Sacado de circulación
                                    </option>
                                </select>
                            </div>

                            <!-- Botón para realizar la búsqueda -->
                            <div class="col-md-1 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>

                        </div>
                    </form>

                    <hr>

                    <!-- Tabla con los resultados de los cheques -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">

                            <thead class="table-dark">
                                <tr>
                                    <th>Número</th>
                                    <th>Fecha</th>
                                    <th>Beneficiario</th>
                                    <th>Monto</th>
                                    <th>Objeto</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>

                            <tbody>

                                <%
                                    // Revisamos si existen cheques para mostrar
                                    if (cheques != null && !cheques.isEmpty()) {

                                        // Recorremos la lista de cheques
                                        for (Cheque cheque : cheques) {
                                %>

                                <tr>
                                    <td><%= cheque.getNumeroCheque() %></td>
                                    <td><%= cheque.getFechaCheque() %></td>
                                    <td><%= escaparHtml(cheque.getNombreProveedor()) %></td>
                                    <td>B/. <%= cheque.getMonto() %></td>
                                    <td><%= escaparHtml(cheque.getDescripcionObjetoGasto()) %></td>

                                    <!-- Estado del cheque -->
                                    <td>
                                        <%
                                            // Convertimos el número del estado en un texto
                                            int estadoCheque = cheque.getEstado();
                                            String textoEstado = "";

                                            if (estadoCheque == 1) {
                                                textoEstado = "Emitido";
                                            } else if (estadoCheque == 2) {
                                                textoEstado = "Pendiente";
                                            } else if (estadoCheque == 3) {
                                                textoEstado = "Cobrado";
                                            } else if (estadoCheque == 4) {
                                                textoEstado = "Anulado";
                                            } else if (estadoCheque == 5) {
                                                textoEstado = "Sacado de circulación";
                                            }
                                        %>

                                        <%= textoEstado %>
                                    </td>
                                </tr>

                                <%
                                        }

                                    // Si la búsqueda no encontró resultados
                                    } else if (cheques != null) {
                                %>

                                <tr>
                                    <td colspan="6" class="text-center text-muted">
                                        No se encontraron cheques.
                                    </td>
                                </tr>

                                <%
                                    }
                                %>

                            </tbody>
                        </table>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal para consultar depósitos -->
    <div class="modal fade" id="modalDepositos" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="bi bi-cash-stack me-2"></i>Consulta de Depósitos
                    </h5>

                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <!-- Formulario para buscar depósitos -->
                    <form method="GET" action="<%= request.getContextPath() %>/ReporteServlet">

                        <!-- Indica al servlet que se están consultando depósitos -->
                        <input type="hidden" name="tipo" value="depositos">

                        <div class="row g-3">

                            <!-- Fecha inicial -->
                            <div class="col-md-2">
                                <label class="form-label">Fecha inicial</label>
                                <input type="date"
                                       name="fechaInicial"
                                       class="form-control"
                                       value="<%= request.getParameter("fechaInicial") != null ? escaparHtml(request.getParameter("fechaInicial")) : "" %>">
                            </div>

                            <!-- Fecha final -->
                            <div class="col-md-2">
                                <label class="form-label">Fecha final</label>
                                <input type="date"
                                       name="fechaFinal"
                                       class="form-control"
                                       value="<%= request.getParameter("fechaFinal") != null ? escaparHtml(request.getParameter("fechaFinal")) : "" %>">
                            </div>

                            <!-- Número del comprobante -->
							<div class="col-md-3">
							    <label class="form-label">Número de comprobante</label>
							    <input type="number"
							           name="numeroComprobante"
							           class="form-control"
							           placeholder="Número"
							           min="1"
							           max="9999"
							           onkeydown="if(['e', 'E', '+', '-', '.'].includes(event.key)) event.preventDefault();"
							           oninput="if(this.value.length > 4) this.value = this.value.slice(0, 4); this.value = this.value.replace(/^0+/, '');"
							           value="<%= request.getParameter("numeroComprobante") != null ? escaparHtml(request.getParameter("numeroComprobante")) : "" %>"
							           required>
							</div>
                            <!-- Tipo de depósito -->
                            <div class="col-md-2">
                                <label class="form-label">Tipo</label>

                                <select name="tipoDeposito" class="form-select">
                                    <option value="">Todos</option>
                                    <option value="1" <%= "1".equals(request.getParameter("tipoDeposito")) ? "selected" : "" %>>
                                        Transferencia
                                    </option>
                                    <option value="2" <%= "2".equals(request.getParameter("tipoDeposito")) ? "selected" : "" %>>
                                        Depósito directo
                                    </option>
                                </select>
                            </div>

                            <!-- Estado del depósito -->
                            <div class="col-md-2">
                                <label class="form-label">Estado</label>

                                <select name="estado" class="form-select">
                                    <option value="">Todos</option>
                                    <option value="1" <%= "1".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Activo
                                    </option>
                                    <option value="0" <%= "0".equals(request.getParameter("estado")) ? "selected" : "" %>>
                                        Inactivo
                                    </option>
                                </select>
                            </div>

                            <!-- Botón para realizar la búsqueda -->
                            <div class="col-md-1 d-flex align-items-end">
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>

                        </div>
                    </form>

                    <hr>

                    <!-- Tabla con los resultados de los depósitos -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">

                            <thead class="table-success">
                                <tr>
                                    <th>Comprobante</th>
                                    <th>Tipo</th>
                                    <th>Fecha</th>
                                    <th>Monto</th>
                                    <th>Detalle</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>

                            <tbody>

                                <%
                                    // Revisamos si existen depósitos para mostrar
                                    if (depositos != null && !depositos.isEmpty()) {

                                        // Recorremos la lista de depósitos
                                        for (Deposito deposito : depositos) {
                                %>

                                <tr>
                                    <td><%= escaparHtml(deposito.getNumeroComprobante()) %></td>

                                    <!-- Muestra el tipo de depósito -->
                                    <td>
                                        <%
                                            // Convertimos el número del tipo en un texto
                                            String tipoTexto = deposito.getTipoDeposito() == 1
                                                    ? "Transferencia"
                                                    : "Depósito directo";
                                        %>

                                        <%= tipoTexto %>
                                    </td>

                                    <td><%= deposito.getFecha() %></td>
                                    <td>B/. <%= deposito.getMonto() %></td>
                                    <td><%= escaparHtml(deposito.getDetalle()) %></td>

                                    <!-- Estado del depósito -->
                                    <td>
                                        <%= deposito.getEstado() == 1 ? "Activo" : "Inactivo" %>
                                    </td>
                                </tr>

                                <%
                                        }

                                    // Si no se encontraron depósitos
                                    } else if (depositos != null) {
                                %>

                                <tr>
                                    <td colspan="6" class="text-center text-muted">
                                        No se encontraron depósitos.
                                    </td>
                                </tr>

                                <%
                                    }
                                %>

                            </tbody>
                        </table>
                    </div>

                    <!-- Muestra el total de los depósitos encontrados -->
                    <div class="text-end mt-3">
                        <strong>Total del período:</strong>

                        <%
                            // Obtiene el total enviado por el servlet
                            Object totalDepositos = request.getAttribute("totalDepositos");
                        %>

                        <span>B/. <%= totalDepositos != null ? totalDepositos : "0.00" %></span>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal para consultar conciliaciones -->
    <div class="modal fade" id="modalConciliaciones" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="bi bi-bank me-2"></i>Consulta de Conciliaciones
                    </h5>

                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <!-- Formulario para buscar conciliaciones -->
                    <form method="GET" action="<%= request.getContextPath() %>/ReporteServlet">

                        <!-- Indica al servlet que se están consultando conciliaciones -->
                        <input type="hidden" name="tipo" value="conciliaciones">

                        <div class="row g-3 align-items-end">

                            <!-- Mes de la conciliación -->
                            <div class="col-md-3">
                                <label class="form-label">Mes</label>

                                <select name="mes" class="form-select">
                                    <option value="">Todos</option>
                                    <option value="01" <%= "01".equals(request.getParameter("mes")) ? "selected" : "" %>>Enero</option>
                                    <option value="02" <%= "02".equals(request.getParameter("mes")) ? "selected" : "" %>>Febrero</option>
                                    <option value="03" <%= "03".equals(request.getParameter("mes")) ? "selected" : "" %>>Marzo</option>
                                    <option value="04" <%= "04".equals(request.getParameter("mes")) ? "selected" : "" %>>Abril</option>
                                    <option value="05" <%= "05".equals(request.getParameter("mes")) ? "selected" : "" %>>Mayo</option>
                                    <option value="06" <%= "06".equals(request.getParameter("mes")) ? "selected" : "" %>>Junio</option>
                                    <option value="07" <%= "07".equals(request.getParameter("mes")) ? "selected" : "" %>>Julio</option>
                                    <option value="08" <%= "08".equals(request.getParameter("mes")) ? "selected" : "" %>>Agosto</option>
                                    <option value="09" <%= "09".equals(request.getParameter("mes")) ? "selected" : "" %>>Septiembre</option>
                                    <option value="10" <%= "10".equals(request.getParameter("mes")) ? "selected" : "" %>>Octubre</option>
                                    <option value="11" <%= "11".equals(request.getParameter("mes")) ? "selected" : "" %>>Noviembre</option>
                                    <option value="12" <%= "12".equals(request.getParameter("mes")) ? "selected" : "" %>>Diciembre</option>
                                </select>
                            </div>

                            <!-- Año de la conciliación -->
                            <div class="col-md-3">
                                <label class="form-label">Año</label>

                                <input type="number"
                                       name="anio"
                                       class="form-control"
                                       placeholder="Ej. 2026"
                                       value="<%= request.getParameter("anio") != null ? escaparHtml(request.getParameter("anio")) : "" %>">
                            </div>

                            <!-- Botón para realizar la búsqueda -->
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-dark w-100">
                                    <i class="bi bi-search me-1"></i>Buscar
                                </button>
                            </div>

                        </div>
                    </form>

                    <hr>

                    <!-- Tabla con los resultados de las conciliaciones -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">

                            <thead class="table-dark">
                                <tr>
                                    <th>Período</th>
                                    <th>Saldo libros</th>
                                    <th>Depósitos en tránsito</th>
                                    <th>Cheques pendientes</th>
                                    <th>Saldo banco</th>
                                    <th>Diferencia</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>

                            <tbody>

                                <%
                                    // Revisamos si existen conciliaciones para mostrar
                                    if (conciliaciones != null && !conciliaciones.isEmpty()) {

                                        // Recorremos la lista de conciliaciones
                                        for (Conciliacion conciliacion : conciliaciones) {
                                %>

                                <tr>
                                    <td><%= conciliacion.getPeriodo() %></td>
                                    <td>B/. <%= conciliacion.getSaldoLibros() %></td>
                                    <td>B/. <%= conciliacion.getDepositosTransito() %></td>
                                    <td>B/. <%= conciliacion.getChequesPendientes() %></td>
                                    <td>B/. <%= conciliacion.getSaldoBanco() %></td>
                                    <td>B/. <%= conciliacion.getDiferencia() %></td>

                                    <!-- Estado de la conciliación -->
                                    <td>
                                        <%
                                            // Convertimos el número del estado en un texto
                                            int estadoConciliacion = conciliacion.getEstado();
                                            String textoEstadoConciliacion = "";

                                            if (estadoConciliacion == 1) {
                                                textoEstadoConciliacion = "En proceso";
                                            } else if (estadoConciliacion == 2) {
                                                textoEstadoConciliacion = "Ajustada";
                                            } else if (estadoConciliacion == 3) {
                                                textoEstadoConciliacion = "Verificada";
                                            } else if (estadoConciliacion == 4) {
                                                textoEstadoConciliacion = "Cerrada";
                                            }
                                        %>

                                        <%= textoEstadoConciliacion %>
                                    </td>
                                </tr>

                                <%
                                        }

                                    // Si no se encontraron conciliaciones
                                    } else if (conciliaciones != null) {
                                %>

                                <tr>
                                    <td colspan="7" class="text-center text-muted">
                                        No se encontraron conciliaciones.
                                    </td>
                                </tr>

                                <%
                                    }
                                %>

                            </tbody>
                        </table>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

    <script>
        // Si el servlet indica un modal, lo abre automáticamente
        document.addEventListener("DOMContentLoaded", function () {

            var modalId = "<%= modalActivo != null ? escaparHtml(modalActivo) : "" %>";

            if (modalId !== "") {

                // Busca el modal que se debe abrir
                var modalElemento = document.getElementById(modalId);

                if (modalElemento) {

                    // Muestra el modal después de cargar la página
                    var modal = new bootstrap.Modal(modalElemento);
                    modal.show();
                }
            }
        });
    </script>

</body>
</html>
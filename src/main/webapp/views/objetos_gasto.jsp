<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ObjetoGasto" %>

<%!
    // Escapa caracteres especiales antes de mostrar texto recibido desde la base de datos.
    public String escaparHtml(String texto) {
        if (texto == null) return "";
        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    // Devuelve el nombre del tipo de objeto de gasto.
    public String nombreTipo(int tipo) {
        if (tipo == 1) return "Servicios";
        if (tipo == 2) return "Materiales y productos";
        if (tipo == 3) return "Equipos";
        if (tipo == 6) return "Comedor escolar / Donaciones";
        return "Otro";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Objetos de gasto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body { background:#f3f5f7; font-family:Arial, Helvetica, sans-serif; }
        .barra-superior { background:#263445; color:white; padding:14px 25px; box-shadow:0 2px 8px rgba(0,0,0,0.08); }
        .contenido-principal { width:calc(100% - 40px); max-width:1380px; margin:30px auto; padding-bottom:30px; }
        .titulo-pagina { color:#263445; font-weight:600; margin-bottom:4px; }
        .subtitulo-pagina { color:#6c757d; margin-bottom:25px; }
        .card { border:none; border-radius:14px; box-shadow:0 3px 12px rgba(0,0,0,0.07); }
        .btn-principal { background:#3f6f9f; border:none; border-radius:8px; }
        .btn-principal:hover { background:#345d86; }
        .form-control, .form-select { border-radius:8px; }
        .form-control:focus, .form-select:focus { border-color:#526d8a; box-shadow:0 0 0 0.2rem rgba(82,109,138,0.15); }
        .table thead th { background:#eef1f5; color:#344054; font-size:13px; font-weight:600; }
        .table tbody { font-size:14px; }
        .table tbody tr:hover { background:#f8f9fa; }
        .badge-tipo { font-size:12px; border-radius:6px; padding:6px 8px; background:#eef1f5; color:#344054; }
    </style>
</head>
<body>

    <!-- Menú lateral y navegación general -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Barra superior -->
    <div class="barra-superior">
        <div class="d-flex justify-content-between align-items-center">
            <strong>Conciliación Bancaria</strong>
            <span>Gestión de objetos de gasto</span>
        </div>
    </div>

    <div class="contenido-principal">

        <!-- Encabezado de la página -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <h2 class="titulo-pagina">Objetos de gasto</h2>
                <p class="subtitulo-pagina">Registre y consulte los objetos que pueden utilizarse en los cheques.</p>
            </div>
        </div>

        <!-- Mensaje de éxito -->
        <% if (request.getParameter("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= escaparHtml(request.getParameter("mensaje")) %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Mensaje de error -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error:</strong> <%= escaparHtml(String.valueOf(request.getAttribute("error"))) %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Formulario para registrar un objeto de gasto -->
        <div class="card mb-4">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-3">Registrar objeto de gasto</h5>

                <form action="<%= request.getContextPath() %>/ObjetoGastoServlet" method="post">
                    <div class="row g-3">

                        <!-- Código -->
                        <div class="col-md-3">
                            <label for="codigo" class="form-label">Código</label>
                            <input type="text"
                                   class="form-control"
                                   id="codigo"
                                   name="codigo"
                                   maxlength="4"
                                   inputmode="numeric"
                                   pattern="^[1-9][0-9]*$"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/^0+/, '')"
                                   title="Solo se permiten números"
                                   value="<%= request.getAttribute("codigo") != null ? escaparHtml(String.valueOf(request.getAttribute("codigo"))) : "" %>"
                                   required>
                        </div>

                        <!-- Descripción con validación de caracteres especiales -->
                        <div class="col-md-5">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <input type="text"
                                   class="form-control"
                                   id="descripcion"
                                   name="descripcion"
                                   maxlength="200"
                                   pattern="^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s.,\-\/]+$"
                                   title="No se permiten caracteres especiales (solo letras, números, espacios y signos .,-/)"
                                   value="<%= request.getAttribute("descripcion") != null ? escaparHtml(String.valueOf(request.getAttribute("descripcion"))) : "" %>"
                                   required>
                        </div>

                        <!-- Tipo -->
                        <div class="col-md-4">
                            <label for="estado" class="form-label">Tipo de objeto de gasto</label>
                            <select class="form-select" id="estado" name="estado" required>
                                <option value="">Seleccione un tipo</option>
                                <option value="1" <%= "1".equals(String.valueOf(request.getAttribute("estado"))) ? "selected" : "" %>>1 - Servicios</option>
                                <option value="2" <%= "2".equals(String.valueOf(request.getAttribute("estado"))) ? "selected" : "" %>>2 - Materiales y productos</option>
                                <option value="3" <%= "3".equals(String.valueOf(request.getAttribute("estado"))) ? "selected" : "" %>>3 - Equipos</option>
                                <option value="6" <%= "6".equals(String.valueOf(request.getAttribute("estado"))) ? "selected" : "" %>>6 - Comedor escolar / Donaciones</option>
                            </select>
                        </div>
                    </div>

                    <!-- Botón de registro -->
                    <div class="mt-4">
                        <button type="submit" class="btn btn-principal text-white px-4">
                            Registrar objeto de gasto
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Lista de objetos registrados -->
        <div class="card">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-3">Objetos de gasto registrados</h5>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Descripción</th>
                                <th>Tipo</th>
                                <th>Fecha de creación</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<ObjetoGasto> objetos =
                                    (List<ObjetoGasto>) request.getAttribute("objetosGasto");

                                if (objetos != null && !objetos.isEmpty()) {
                                    for (ObjetoGasto objeto : objetos) {
                            %>
                            <tr>
                                <td><%= escaparHtml(objeto.getCodigo()) %></td>
                                <td><%= escaparHtml(objeto.getDescripcion()) %></td>
                                <td><span class="badge-tipo"><%= nombreTipo(objeto.getEstado()) %></span></td>
                                <td><%= objeto.getFechaCreacion() != null ? objeto.getFechaCreacion() : "" %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center text-muted">No hay objetos de gasto registrados.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts de validación en tiempo real -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const campoCodigo = document.getElementById("codigo");
            const campoDescripcion = document.getElementById("descripcion");

            // Solo permite números en el código
            if (campoCodigo) {
                campoCodigo.addEventListener("input", function () {
                    this.value = this.value.replace(/[^0-9]/g, "");
                });
            }

            // Remueve caracteres especiales en la descripción mientras escribe o pega texto
            if (campoDescripcion) {
                // Expresión regular: permite letras, números, acentos, ñ/Ñ, espacios y .,-/
                const regexPermitidos = /[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s.,\-\/]/g;

                campoDescripcion.addEventListener("input", function () {
                    this.value = this.value.replace(regexPermitidos, "");
                });
            }
        });
    </script>
</body>
</html>
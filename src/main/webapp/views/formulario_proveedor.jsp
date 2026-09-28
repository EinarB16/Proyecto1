<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Proveedor" %>

<%
    Proveedor proveedor =
        (Proveedor) request.getAttribute("proveedor");

    boolean modoEdicion =
        Boolean.TRUE.equals(
            request.getAttribute("modoEdicion")
        );
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <%= modoEdicion ? "Editar proveedor" : "Registrar proveedor" %>
    </title>

    <style>
        body {
            background: #f3f5f7;
            margin: 0 !important;
            padding: 0 !important;
            font-family: Arial, Helvetica, sans-serif;
        }

        .barra-superior {
            background: #263445 !important;
            margin-top: 0 !important;
            margin-left: 70px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
            transition: margin-left 0.3s ease;
        }

        .menu-expandido .barra-superior {
            margin-left: 250px;
        }

        .navbar-brand {
            font-weight: 600;
        }

        .contenido-principal {
            width: calc(100% - 110px);
            max-width: 1380px;
            margin: 30px 20px 30px 90px;
            padding-bottom: 30px;
            transition: margin-left 0.3s ease, width 0.3s ease;
        }

        .menu-expandido .contenido-principal {
            width: calc(100% - 290px);
            margin-left: 270px;
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

        .tarjeta-formulario {
            border: none;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .cabecera-formulario {
            background: #263445;
            color: white;
            padding: 16px 24px;
        }

        .cabecera-formulario h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }

        .cuerpo-formulario {
            padding: 24px;
        }

        .form-label {
            color: #344054;
            font-weight: 600;
            font-size: 14px;
        }

        .form-control {
            border-radius: 8px;
            border: 1px solid #d9dee5;
        }

        .form-control:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82,109,138,0.15);
        }

        .boton-principal {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 17px;
        }

        .boton-principal:hover {
            background: #345d86;
        }

        .boton-cancelar {
            border-radius: 8px;
            padding: 9px 17px;
        }

        .modal-content {
            border: none;
            border-radius: 14px;
            overflow: hidden;
        }

        .modal-header {
            border-bottom: none;
        }

        .modal-footer {
            background: #f8f9fa;
        }

        @media (max-width: 768px) {
            .barra-superior {
                margin-left: 70px;
            }

            .contenido-principal,
            .menu-expandido .contenido-principal {
                width: calc(100% - 90px);
                margin: 20px 15px 20px 85px;
            }

            .cuerpo-formulario {
                padding: 18px;
            }
        }
    </style>
</head>

<body>
    <!-- Menú principal -->
    <%@ include file="../includes/menu.jsp" %>

    <nav class="navbar navbar-dark barra-superior">
        <div class="container-fluid px-4">
            <span class="navbar-brand">Conciliación Bancaria</span>

            <div class="d-flex align-items-center">
                <span class="text-white me-3">
                    Bienvenido, <strong><%= session.getAttribute("nombreUsuario") %></strong>
                </span>

                <a href="<%= request.getContextPath() %>/LogoutServlet"
                   class="btn btn-light btn-sm">
                    Cerrar sesión
                </a>
            </div>
        </div>
    </nav>

    <%
        String error = (String) request.getAttribute("error");

        boolean mostrarModalRuc =
            Boolean.TRUE.equals(request.getAttribute("mostrarModalRuc"));
    %>

    <% if (mostrarModalRuc) { %>
        <div class="modal fade"
             id="modalRucDuplicado"
             tabindex="-1"
             aria-labelledby="modalRucDuplicadoLabel"
             aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title"
                            id="modalRucDuplicadoLabel">
                            RUC ya registrado
                        </h5>

                        <button type="button"
                                class="btn-close btn-close-white"
                                data-bs-dismiss="modal"
                                aria-label="Cerrar">
                        </button>
                    </div>

                    <div class="modal-body">
                        <p class="mb-0">
                            <%= error %>
                        </p>
                    </div>

                    <div class="modal-footer">
                        <button type="button"
                                class="btn btn-secondary"
                                data-bs-dismiss="modal">
                            Cerrar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const modalElemento =
                    document.getElementById("modalRucDuplicado");

                if (modalElemento) {
                    const modal =
                        bootstrap.Modal.getOrCreateInstance(modalElemento);

                    modal.show();
                }
            });
        </script>
    <% } %>

    <div class="container contenido-principal">
        <!-- =====================================================
             ENCABEZADO
             ===================================================== -->
        <div class="mb-4">
            <h2 class="titulo-pagina">
                <%= modoEdicion
                    ? "Editar proveedor"
                    : "Registrar proveedor" %>
            </h2>

            <p class="subtitulo-pagina">
                <%= modoEdicion
                    ? "Modificar los datos del proveedor seleccionado"
                    : "Registrar un nuevo proveedor del sistema" %>
            </p>
        </div>

        <!-- =====================================================
             MENSAJE DE ERROR
             ===================================================== -->
        <% if (request.getAttribute("error") != null && !mostrarModalRuc) { %>
            <div class="alert alert-danger alert-dismissible fade show"
                 role="alert">
                <strong>¡Error!</strong>
                <%= request.getAttribute("error") %>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Cerrar">
                </button>
            </div>
        <% } %>

        <!-- =====================================================
             FORMULARIO
             ===================================================== -->
        <div class="card tarjeta-formulario">
            <div class="cabecera-formulario">
                <h3>
                    <%= modoEdicion
                        ? "Datos del proveedor"
                        : "Nuevo proveedor" %>
                </h3>
            </div>

            <div class="card-body cuerpo-formulario">
                <form action="<%= request.getContextPath() %>/ProveedorServlet"
                      method="post">

                    <!-- =================================================
                         ACCIÓN
                         ================================================= -->
                    <input type="hidden"
                           name="accion"
                           value="<%= modoEdicion ? "actualizar" : "registrar" %>">

                    <!-- =================================================
                         ID DEL PROVEEDOR
                         Solo se envía cuando estamos editando.
                         ================================================= -->
                    <% if (modoEdicion && proveedor != null) { %>
                        <input type="hidden"
                               name="idProveedor"
                               value="<%= proveedor.getIdProveedor() %>">
                    <% } %>

                    <div class="row g-3">
                        <!-- =================================================
                             RUC
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="ruc"
                                   class="form-label">
                                RUC
                                <span class="text-danger">*</span>
                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="ruc"
                                   name="ruc"
                                   maxlength="15"
                                   pattern="[0-9\-]+"
                                   title="Solo números y guiones."
                                   autocomplete="off"
                                   oninput="this.value = this.value.replace(/[^0-9\-]/g, '')"
                                   required
                                   placeholder="Ingrese el RUC"
                                   value="<%= modoEdicion
                                            && proveedor != null
                                            && proveedor.getRuc() != null
                                            ? proveedor.getRuc()
                                            : "" %>">
                        </div>

                        <!-- =================================================
                             NOMBRE
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="nombre"
                                   class="form-label">
                                Nombre del proveedor
                                <span class="text-danger">*</span>
                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="nombre"
                                   name="nombre"
                                   autocomplete="off"
                                   maxlength="15"
                                   pattern="[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ .,&'\-]+"
                                   title="Letras, números, espacios y puntuación básica (. , & ' )."
                                   oninput="this.value = this.value.replace(/[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ .,&'\-]/g, '')"
                                   required
                                   placeholder="Ingrese el nombre"
                                   value="<%= modoEdicion
                                            && proveedor != null
                                            && proveedor.getNombre() != null
                                            ? proveedor.getNombre()
                                            : "" %>">
                        </div>

                        <!-- =================================================
                             TELÉFONO
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="telefono"
                                   class="form-label">
                                Teléfono
                            </label>

                            <input type="tel"
                                   class="form-control"
                                   id="telefono"
                                   name="telefono"
                                   autocomplete="off"
                                   maxlength="9"
                                   pattern="[0-9]{3,4}-[0-9]{4}"
                                   title="Formato: 800-1234 o 6123-4567"
                                   oninput="this.value = this.value.replace(/[^0-9\-]/g, '')"
                                   placeholder="Ej: 6123-4567"
                                   value="<%= modoEdicion
                                            && proveedor != null
                                            && proveedor.getTelefono() != null
                                            ? proveedor.getTelefono()
                                            : "" %>">
                        </div>

                        <!-- =================================================
                             CORREO
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="correo"
                                   class="form-label">
                                Correo electrónico
                            </label>

                            <input type="email"
                                   class="form-control"
                                   id="correo"
                                   name="correo"
                                   autocomplete="off"
                                   maxlength="25"
                                   pattern="[a-zA-Z0-9\_.]+@[a-zA-Z0-9\_.]+"
                                   title="Solo letras, números, guion bajo (_) y punto (.). El @ es obligatorio."
                                   oninput="this.value = this.value.replace(/[^a-zA-Z0-9\_.@]/g, '')"
                                   placeholder="ejemplo@correo.com"
                                   value="<%= modoEdicion
                                            && proveedor != null
                                            && proveedor.getCorreo() != null
                                            ? proveedor.getCorreo()
                                            : "" %>">
                        </div>
                    </div>

                    <!-- =================================================
                         BOTONES
                         ================================================= -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit"
                                class="btn boton-principal text-white">
                            <%= modoEdicion
                                ? "Guardar cambios"
                                : "Guardar proveedor" %>
                        </button>

                        <a href="<%= request.getContextPath() %>/ProveedorServlet"
                           class="btn btn-secondary boton-cancelar">
                            Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
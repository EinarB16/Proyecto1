<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <%= Boolean.TRUE.equals(request.getAttribute("modoEdicion"))
                ? "Editar usuario"
                : "Nuevo usuario" %>
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

        .form-control,
        .form-select {
            border-radius: 8px;
            border: 1px solid #d9dee5;
        }

        .form-control:focus,
        .form-select:focus {
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
        boolean modoEdicion =
                Boolean.TRUE.equals(request.getAttribute("modoEdicion"));

        Usuario usuarioEditar =
                (Usuario) request.getAttribute("usuario");
    %>

    <div class="container contenido-principal">
        <!-- ====================================================
             ENCABEZADO
             ===================================================== -->
        <div class="mb-4">
            <h2 class="titulo-pagina">
                <%= modoEdicion
                        ? "Editar usuario"
                        : "Crear usuario" %>
            </h2>

            <p class="subtitulo-pagina">
                <%= modoEdicion
                        ? "Modificar los datos del usuario seleccionado"
                        : "Registrar un nuevo usuario del sistema" %>
            </p>
        </div>

        <!-- =====================================================
             MENSAJE DE ERROR DEL SERVLET
             ===================================================== -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show"
                 role="alert">
                <strong>¡Error!</strong>
                <%= request.getAttribute("error") %>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
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
                            ? "Datos del usuario"
                            : "Nuevo usuario" %>
                </h3>
            </div>

            <div class="card-body cuerpo-formulario">
                <form action="<%= request.getContextPath() %>/UsuarioServlet"
                      method="post"
                      id="formUsuario"
                      class="needs-validation"
                      novalidate>

                    <!-- =================================================
                         ACCIÓN
                         ================================================= -->
                    <input type="hidden"
                           name="accion"
                           value="<%= modoEdicion
                                   ? "actualizar"
                                   : "registrar" %>">

                    <!-- =================================================
                         ID DEL USUARIO
                         Solo se utiliza al editar
                         ================================================= -->
                    <% if (modoEdicion && usuarioEditar != null) { %>
                        <input type="hidden"
                               name="idUsuario"
                               value="<%= usuarioEditar.getIdUsuario() %>">
                    <% } %>

                    <div class="row g-3">
                        <!-- =================================================
                             NOMBRE
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="nombre"
                                   class="form-label">
                                Nombre
                            </label>

                            <input type="text"
                                   id="nombre"
                                   name="nombre"
                                   autocomplete="off"
                                   class="form-control"
                                   autocomplete="off"
                                   maxlength="15"
                                   pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"
                                   oninput="this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '')"
                                   value="<%= modoEdicion && usuarioEditar != null
                                           ? usuarioEditar.getNombre()
                                           : "" %>"
                                   required>

                            <div class="invalid-feedback">
                                Ingrese un nombre válido (solo letras).
                            </div>
                        </div>

                        <!-- =================================================
                             APELLIDO
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="apellido"
                                   class="form-label">
                                Apellido
                            </label>

                            <input type="text"
                                   id="apellido"
                                   name="apellido"
                                   autocomplete="off"
                                   class="form-control"
                                   maxlength="15"
                                   pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"
                                   oninput="this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '')"
                                   value="<%= modoEdicion && usuarioEditar != null
                                           ? usuarioEditar.getApellido()
                                           : "" %>"
                                   required>

                            <div class="invalid-feedback">
                                Ingrese un apellido válido (solo letras).
                            </div>
                        </div>

                        <!-- =================================================
                             USUARIO
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="usuario"
                                   class="form-label">
                                Nombre de usuario
                            </label>

                            <input type="text"
                                   id="usuario"
                                   name="usuario"
                                   autocomplete="off"
                                   class="form-control"
                                   minlength="4"
                                   maxlength="15"
                                   pattern="^[a-zA-Z0-9\_.]+$"
                                   oninput="this.value = this.value.replace(/[^a-zA-Z0-9\_.]/g, '')"
                                   value="<%= modoEdicion && usuarioEditar != null
                                           ? usuarioEditar.getUsuario()
                                           : "" %>"
                                   required>

                            <div class="form-text">
                                Mínimo 4 caracteres (sin espacios, comillas ni símbolos raros).
                            </div>

                            <div class="invalid-feedback">
                                El usuario debe tener entre 4 y 20 caracteres
                                (solo letras, números, puntos y _).
                            </div>
                        </div>

                        <!-- =================================================
                             CONTRASEÑA
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="password"
                                   class="form-label">
                                Contraseña
                            </label>

                            <input type="password"
                                   id="password"
                                   name="password"
                                   autocomplete="off"
                                   class="form-control"
                                   minlength="6"
                                   maxlength="15"
                                   <%= modoEdicion ? "" : "required" %>>

                            <% if (modoEdicion) { %>
                                <div class="form-text">
                                    Déjela vacía para conservar la contraseña actual.
                                </div>
                            <% } %>

                            <div class="invalid-feedback">
                                La contraseña debe tener al menos 6 caracteres.
                            </div>
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
                                   id="correo"
                                   name="correo"
                                   autocomplete="off"
                                   class="form-control"
                                   maxlength="25"
                                   oninput="this.value = this.value.replace(/[^a-zA-Z0-9\_.@-]/g, '')"
                                   value="<%= modoEdicion && usuarioEditar != null
                                           ? usuarioEditar.getCorreo()
                                           : "" %>"
                                   required>

                            <div class="invalid-feedback">
                                Ingrese un correo electrónico válido.
                            </div>
                        </div>

                        <!-- =================================================
                             ROL
                             ================================================= -->
                        <div class="col-md-6">
                            <label for="rol"
                                   class="form-label">
                                Rol
                            </label>

                            <select id="rol"
                                    name="rol"
                                    class="form-select"
                                    required>
                                <option value="">
                                    Seleccione un rol
                                </option>

                                <option value="ADMIN"
                                    <%= modoEdicion
                                            && usuarioEditar != null
                                            && "ADMIN".equalsIgnoreCase(
                                                usuarioEditar.getRol())
                                            ? "selected"
                                            : "" %>>
                                    Administrador
                                </option>

                                <option value="CONTADOR"
                                    <%= modoEdicion
                                            && usuarioEditar != null
                                            && "CONTADOR".equalsIgnoreCase(
                                                usuarioEditar.getRol())
                                            ? "selected"
                                            : "" %>>
                                    Contador
                                </option>

                                <option value="AUXILIAR"
                                    <%= modoEdicion
                                            && usuarioEditar != null
                                            && "AUXILIAR".equalsIgnoreCase(
                                                usuarioEditar.getRol())
                                            ? "selected"
                                            : "" %>>
                                    Auxiliar
                                </option>
                            </select>

                            <div class="invalid-feedback">
                                Seleccione un rol de la lista.
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         BOTONES
                         ===================================================== -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit"
                                class="btn boton-principal text-white">
                            <%= modoEdicion
                                    ? "Actualizar usuario"
                                    : "Crear usuario" %>
                        </button>

                        <a href="<%= request.getContextPath() %>/UsuarioServlet"
                           class="btn btn-secondary boton-cancelar">
                            Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- =====================================================
         SCRIPT DE VALIDACIÓN
         ===================================================== -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const form = document.getElementById("formUsuario");
            const inputUsuario = document.getElementById("usuario");

            // No permite espacios en el nombre de usuario
            inputUsuario.addEventListener("input", function () {
                this.value = this.value.replace(/\s+/g, '');
            });

            // Validación de Bootstrap
            form.addEventListener("submit", function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                form.classList.add("was-validated");
            }, false);
        });
    </script>
</body>
</html>
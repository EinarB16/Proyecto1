<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de sesión</title>

    <style>
        /* Fondo general de la página */
        body {
            background: #eef1f5;
        }

        /* Hace que el formulario quede centrado verticalmente */
        .contenedor-login {
            min-height: 100vh;
        }

        /* Tarjeta principal del inicio de sesión */
        .tarjeta-login {
            border: none;
            border-radius: 16px;
            overflow: hidden;
        }

        /* Encabezado de la tarjeta */
        .encabezado-login {
            background: #263445;
            color: white;
            padding: 25px 20px;
            text-align: center;
        }

        /* Título del sistema */
        .encabezado-login h2 {
            font-size: 24px;
            margin-bottom: 6px;
            font-weight: 600;
        }

        /* Texto debajo del título */
        .encabezado-login p {
            margin: 0;
            color: #d5dbe2;
            font-size: 14px;
        }

        /* Espaciado interno del formulario */
        .cuerpo-login {
            padding: 30px;
        }

        /* Campos de usuario y contraseña */
        .form-control {
            border-radius: 9px;
            padding: 10px 12px;
        }

        /* Estilo de los campos cuando están seleccionados */
        .form-control:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82, 109, 138, 0.15);
        }

        /* Botón para iniciar sesión */
        .btn-login {
            background: #3f6f9f;
            border: none;
            border-radius: 9px;
            padding: 10px;
            font-weight: 500;
        }

        /* Cambio de color del botón al pasar el mouse */
        .btn-login:hover {
            background: #345d86;
        }

        /* Título del formulario */
        .titulo-formulario {
            color: #344054;
            font-weight: 600;
        }
    </style>
</head>

<body>
    <!-- Contenedor principal del formulario -->
    <div class="container">
        <div class="row justify-content-center align-items-center contenedor-login">
            <div class="col-md-6 col-lg-5 col-xl-4">
                <!-- Tarjeta que contiene el inicio de sesión -->
                <div class="card shadow-sm tarjeta-login">
                    <!-- Encabezado con el nombre y descripción del sistema -->
                    <div class="encabezado-login">
                        <h2>Sistema de Conciliación Bancaria</h2>
                        <p>Gestión y control de operaciones bancarias</p>
                    </div>

                    <!-- Cuerpo donde se encuentra el formulario -->
                    <div class="card-body cuerpo-login">
                        <h5 class="text-center titulo-formulario mb-4">Iniciar sesión</h5>

                        <!-- Muestra el mensaje de error enviado por el LoginServlet -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger">
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>

                        <!-- Formulario que envía el usuario y contraseña al LoginServlet -->
                        <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
                            <!-- Campo para ingresar el nombre de usuario -->
                            <div class="mb-3">
                                <label for="usuario" class="form-label">Usuario</label>
                                <input type="text"
                                       class="form-control"
                                       id="usuario"
                                       name="usuario"
                                       autocomplete="off"
                                       maxlength="15"
                                       pattern="[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ]+"
                                       title="Solo se permiten letras y números, sin caracteres especiales."
                                       required>
                            </div>

                            <!-- Campo para ingresar la contraseña -->
                            <div class="mb-4">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password"
                                       class="form-control"
                                       id="password"
                                       name="password"
                                       maxlength="15"
                                       autocomplete="new-password"
                                       pattern="[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ]+"
                                       title="Solo se permiten letras y números, sin caracteres especiales."
                                       required>
                            </div>

                            <!-- Botón para enviar el formulario -->
                            <div class="d-grid">
                                <button type="submit" class="btn btn-login text-white">Iniciar sesión</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Espera a que la página termine de cargar antes de configurar las validaciones
        document.addEventListener("DOMContentLoaded", function () {
            // Expresión que permite solamente letras y números
            const patronValido = /^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ]$/;

            // Obtiene los campos donde se aplicará la validación
            const campos = [
                document.getElementById("usuario"),
                document.getElementById("password")
            ];

            // Aplica las validaciones a cada campo
            campos.forEach(function (campo) {
                if (!campo) return;

                // Bloquea teclas que no sean letras o números
                campo.addEventListener("keydown", function (evento) {
                    // Permite teclas especiales como Backspace, Shift, Tab, etc.
                    if (evento.key.length > 1) {
                        return;
                    }

                    // Cancela la tecla si no cumple con el patrón permitido
                    if (!patronValido.test(evento.key)) {
                        evento.preventDefault();
                    }
                });

                // Evita pegar texto que contenga caracteres no permitidos
                campo.addEventListener("paste", function (evento) {
                    const texto = (evento.clipboardData || window.clipboardData).getData("text");

                    // Cancela el pegado si el texto contiene caracteres especiales
                    if (!/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ]+$/.test(texto)) {
                        evento.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>
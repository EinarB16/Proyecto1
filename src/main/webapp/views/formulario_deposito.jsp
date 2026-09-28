<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar depósito - Conciliación Bancaria</title>

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

        .input-group-text {
            background: #eef1f5;
            border: 1px solid #d9dee5;
            color: #344054;
            font-weight: 600;
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

    <!-- =====================================================
         BARRA SUPERIOR
         ===================================================== -->
    <nav class="navbar navbar-dark barra-superior">
        <div class="container-fluid px-4">
            <span class="navbar-brand">
                Conciliación Bancaria
            </span>

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

    <!-- =====================================================
         FORMULARIO
         ===================================================== -->
    <div class="container contenido-principal">
        <!-- ENCABEZADO -->
        <div class="mb-4">
            <h2 class="titulo-pagina">
                Registrar depósito
            </h2>

            <p class="subtitulo-pagina">
                Complete los datos necesarios para registrar un depósito.
            </p>
        </div>

        <div class="card tarjeta-formulario">
            <div class="cabecera-formulario">
                <h3>
                    Datos del depósito
                </h3>
            </div>

            <div class="card-body cuerpo-formulario">
                <!-- Mensaje de error -->
                <%
                    String error =
                        (String) request.getAttribute("error");

                    if (error != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show"
                         role="alert">
                        <strong>¡Error!</strong>
                        <%= error %>

                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="alert"
                                aria-label="Cerrar">
                        </button>
                    </div>
                <%
                    }
                %>

                <!-- Formulario -->
                <form method="post"
                      action="<%= request.getContextPath() %>/DepositoServlet">

                    <!-- Acción -->
                    <input type="hidden"
                           name="accion"
                           value="registrar">

                    <div class="row g-3">
                        <!-- Número de comprobante -->
                        <div class="col-md-4">
                            <label for="numeroComprobante"
                                   class="form-label">
                                Número de comprobante
                                <span class="text-danger">*</span>
                            </label>

                            <input type="text"
                                   id="numeroComprobante"
                                   name="numeroComprobante"
                                   class="form-control"
                                   value="<%= request.getAttribute("siguienteComprobante") != null
                                                ? request.getAttribute("siguienteComprobante")
                                                : "" %>"
                                   readonly>
                        </div>

                        <!-- Tipo de depósito -->
                        <div class="col-md-4">
                            <label for="tipoDeposito"
                                   class="form-label">
                                Tipo de depósito
                                <span class="text-danger">*</span>
                            </label>

                            <select id="tipoDeposito"
                                    name="tipoDeposito"
                                    class="form-select"
                                    required>
                                <option value="">
                                    Seleccione un tipo
                                </option>

                                <option value="1">
                                    Transferencia
                                </option>

                                <option value="2">
                                    Depósito directo
                                </option>
                            </select>
                        </div>

                        <!-- Fecha -->
                        <div class="col-md-4">
                            <label for="fecha"
                                   class="form-label">
                                Fecha
                                <span class="text-danger">*</span>
                            </label>

                            <input type="date"
                                   id="fecha"
                                   name="fecha"
                                   class="form-control"
                                   required>
                        </div>

                        <!-- Monto -->
                        <div class="col-md-6">
                            <label for="monto"
                                   class="form-label">
                                Monto
                                <span class="text-danger">*</span>
                            </label>

                            <div class="input-group">
                                <span class="input-group-text">
                                    B/.
                                </span>                             
						    <input type="number"
						           id="monto"
						           name="monto"
						           class="form-control"
						           min="0.01"
						           max="9999999.99"
						           step="0.01"
						           placeholder="Ejemplo: 1250.50"
						           onkeydown="if(['e', 'E', '+', '-'].includes(event.key)) event.preventDefault();"
						           oninput="if(parseFloat(this.value) > 9999999.99) this.value = 9999999.99;"
						           required>
						</div>
                        </div>
                        <!-- Detalle -->
                        <div class="col-md-6">
                            <label for="detalle"
                                   class="form-label">
                                Detalle
                            </label>

                            <textarea id="detalle"
                                      name="detalle"
                                      class="form-control"
                                      rows="4"
                                      maxlength="300"
                                      oninput="this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '')"></textarea>

                            <div class="form-text">
                                Máximo 300 caracteres. Solo letras.
                            </div>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit"
                                class="btn boton-principal text-white">
                            Registrar depósito
                        </button>

                        <a href="<%= request.getContextPath() %>/DepositoServlet"
                           class="btn btn-secondary boton-cancelar">
                            Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bloqueo en tiempo real de "e", "E", "+", "-" en el campo Monto -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const campoMonto = document.getElementById("monto");

            if (campoMonto) {
                campoMonto.addEventListener("keydown", function (evento) {
                    if (["e", "E", "+", "-"].includes(evento.key)) {
                        evento.preventDefault();
                    }
                });

                campoMonto.addEventListener("paste", function (evento) {
                    const texto =
                        (evento.clipboardData || window.clipboardData)
                            .getData("text");

                    if (/[eE+\-]/.test(texto)) {
                        evento.preventDefault();
                    }
                });
            }
        });
    </script>
</body>
</html>
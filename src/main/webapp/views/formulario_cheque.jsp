<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Proveedor" %>
<%@ page import="model.ObjetoGasto" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Cheque</title>

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

        .boton-registrar {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 17px;
        }

        .boton-registrar:hover {
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

    <div class="container contenido-principal">
        <!-- ENCABEZADO -->
        <div class="mb-4">
            <h2 class="titulo-pagina">Registrar Cheque</h2>
            <p class="subtitulo-pagina">Complete los datos necesarios para registrar un cheque.</p>
        </div>

        <div class="card tarjeta-formulario">
            <div class="cabecera-formulario">
                <h3>Datos del cheque</h3>
            </div>

            <div class="card-body cuerpo-formulario">
                <!-- ==========================================
                     MENSAJE DE ERROR
                     ========================================== -->
                <%
                    if (request.getAttribute("error") != null) {
                %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <%
                    }
                %>

                <!-- ==========================================
                     FORMULARIO
                     ========================================== -->
                <form action="${pageContext.request.contextPath}/ChequeServlet"
                      method="post"
                      id="formCheque">

                    <!-- Indicamos que queremos registrar -->
                    <input type="hidden"
                           name="accion"
                           value="registrar">

                    <div class="row g-3">
                        <!-- ======================================
                             NÚMERO DE CHEQUE
                             ====================================== -->
                        <div class="col-md-4">
                            <label for="numeroCheque"
                                   class="form-label">
                                Número de cheque
                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="numeroCheque"
                                   name="numeroCheque"
                                   value="${siguienteNumero}"
                                   readonly
                                   required>
                        </div>

                        <!-- ======================================
                             FECHA
                             ====================================== -->
                        <div class="col-md-4">
                            <label for="fechaCheque"
                                   class="form-label">
                                Fecha del cheque
                            </label>

                            <input type="date"
                                   class="form-control"
                                   id="fechaCheque"
                                   name="fechaCheque"
                                   required>
                        </div>

                        <!-- ======================================
                             MONTO
                             ====================================== -->
                        <div class="col-md-4">
                            <label for="monto"
                                   class="form-label">
                                Monto
                            </label>
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
                        <!-- ======================================
                             PROVEEDOR
                             ====================================== -->
                        <div class="col-md-6">
                            <label for="idProveedor"
                                   class="form-label">
                                Proveedor
                            </label>

                            <select class="form-select"
                                    id="idProveedor"
                                    name="idProveedor"
                                    required>
                                <option value="">
                                    Seleccione un proveedor
                                </option>

                                <%
                                    List<Proveedor> proveedores =
                                        (List<Proveedor>) request.getAttribute("proveedores");

                                    if (proveedores != null && !proveedores.isEmpty()) {
                                        for (Proveedor proveedor : proveedores) {
                                %>
                                    <option value="<%= proveedor.getIdProveedor() %>">
                                        <%= proveedor.getNombre() %>
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <!-- ======================================
                             OBJETO DE GASTO
                             ====================================== -->
                        <div class="col-md-6">
                            <label for="idObjetoGasto"
                                   class="form-label">
                                Objeto de gasto
                            </label>

                            <select class="form-select"
                                    id="idObjetoGasto"
                                    name="idObjetoGasto"
                                    required>
                                <option value="">
                                    Seleccione un objeto de gasto
                                </option>

                                <%
                                    List<ObjetoGasto> objetosGasto =
                                        (List<ObjetoGasto>) request.getAttribute("objetosGasto");

                                    if (objetosGasto != null && !objetosGasto.isEmpty()) {
                                        for (ObjetoGasto objeto : objetosGasto) {
                                %>
                                    <option value="<%= objeto.getIdObjetoGasto() %>">
                                        <%= objeto.getCodigo() %> - <%= objeto.getDescripcion() %>
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <!-- ======================================
                             MONTO EN LETRAS
                             ====================================== -->
                        <div class="col-md-6">
                            <label for="montoLetras"
                                   class="form-label">
                                Monto en letras
                            </label>

                            <textarea
                                class="form-control"
                                id="montoLetras"
                                name="montoLetras"
                                placeholder="El monto se generará automáticamente"
                                maxlength="300"
                                rows="3"
                                readonly
                                required></textarea>
                        </div>

                        <!-- ======================================
                             DETALLE
                             ====================================== -->
                        <div class="col-md-6">
                            <label for="detalle"
                                   class="form-label">
                                Detalle
                            </label>

                            <textarea
                                class="form-control"
                                id="detalle"
                                name="detalle"
                                placeholder="Escriba una descripción del cheque"
                                maxlength="300"
                                rows="3"
                                oninput="this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ ]/g, '')"></textarea>
                        </div>
                    </div>

                    <!-- ======================================
                         BOTONES
                         ====================================== -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit"
                                class="btn boton-registrar text-white">
                            Registrar cheque
                        </button>

                        <a href="${pageContext.request.contextPath}/ChequeServlet"
                           class="btn btn-secondary boton-cancelar">
                            Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Carga el archivo JavaScript con las funciones del formulario -->
    <script src="${pageContext.request.contextPath}/js/funciones.js"></script>

    <!-- Bloqueo directo de "e", "E", "+", "-" en el campo Monto -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const campoMonto = document.getElementById("monto");

            if (campoMonto) {
                // Bloquea la tecla mientras se escribe
                campoMonto.addEventListener("keydown", function (evento) {
                    if (["e", "E", "+", "-"].includes(evento.key)) {
                        evento.preventDefault();
                    }
                });

                // Bloquea que se pegue con Ctrl+V
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
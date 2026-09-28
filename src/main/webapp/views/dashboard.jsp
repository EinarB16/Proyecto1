<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>

    <!-- Bootstrap para el diseño de la interfaz -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Configuración básica de la página -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Conciliación Bancaria</title>

    <style>
        /* Fondo general del Dashboard */
        body {
            background: #f3f5f7;
        }

        /* Contenedor principal del contenido */
        .contenido-principal {
            max-width: 1200px;
            margin: 30px auto;
            padding-bottom: 30px;
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

        /* Título principal del Dashboard */
        .titulo-dashboard {
            font-weight: 600;
            color: #263445;
            margin-bottom: 4px;
        }

        /* Descripción debajo del título */
        .subtitulo-dashboard {
            color: #6c757d;
            margin-bottom: 25px;
        }

        /* Tarjetas que muestran las estadísticas */
        .tarjeta-estadistica {
            border: none;
            border-radius: 14px;
            min-height: 145px;
            background: #ffffff;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            overflow: hidden;
            position: relative;
        }

        /* Efecto de las tarjetas al pasar el cursor */
        .tarjeta-estadistica:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.10);
        }

        /* Línea lateral que identifica las tarjetas */
        .tarjeta-estadistica::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
            background: #3f6f9f;
        }

        /* Color de la línea para cheques pendientes */
        .tarjeta-pendiente::before {
            background: #d9a441;
        }

        /* Color de la línea para cheques anulados */
        .tarjeta-anulada::before {
            background: #c94c4c;
        }

        /* Color de la línea para cantidad de depósitos */
        .tarjeta-deposito::before {
            background: #4b9560;
        }

        /* Color de la línea para monto de cheques */
        .tarjeta-monto-cheque::before {
            background: #3f6f9f;
        }

        /* Color de la línea para monto de depósitos */
        .tarjeta-monto-deposito::before {
            background: #4b9560;
        }

        /* Color de la línea para la última conciliación */
        .tarjeta-conciliacion::before {
            background: #6c757d;
        }

        /* Espaciado interno de las tarjetas */
        .tarjeta-estadistica .card-body {
            padding: 22px;
        }

        /* Nombre de cada estadística */
        .titulo-estadistica {
            color: #6c757d;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* Número principal de las estadísticas */
        .numero-estadistica {
            font-size: 32px;
            font-weight: 700;
            color: #263445;
        }

        /* Tamaño de los montos de dinero */
        .monto-estadistica {
            font-size: 25px;
            font-weight: 700;
        }

        /* Descripción de cada estadística */
        .descripcion-estadistica {
            color: #8a929a;
            font-size: 13px;
            margin-top: 8px;
            margin-bottom: 0;
        }

        /* Título de las secciones */
        .seccion-titulo {
            color: #263445;
            font-weight: 600;
            margin-bottom: 4px;
        }

        /* Descripción de las secciones */
        .seccion-descripcion {
            color: #6c757d;
            margin-bottom: 18px;
        }

        /* Tarjeta de información de acceso */
        .tarjeta-acceso {
            border: none;
            border-radius: 14px;
            background: #ffffff;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
        }

        /* Efecto al pasar el cursor sobre una tarjeta de acceso */
        .tarjeta-acceso:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.10);
        }

        /* Espaciado interno de las tarjetas de acceso */
        .tarjeta-acceso .card-body {
            padding: 22px;
        }

        /* Título de las tarjetas de acceso */
        .titulo-acceso {
            color: #263445;
            font-weight: 600;
        }

        /* Texto descriptivo de las tarjetas de acceso */
        .texto-acceso {
            color: #6c757d;
            font-size: 14px;
            min-height: 42px;
        }

        /* Botones de acceso */
        .btn-acceso {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
        }

        /* Cambio de color al pasar el cursor */
        .btn-acceso:hover {
            background: #345d86;
        }

        /* Tarjeta que contiene la información de la sesión */
        .tarjeta-sesion {
            border: none;
            border-radius: 14px;
            background: #ffffff;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
        }

        /* Contenedor de cada dato de la sesión */
        .dato-sesion {
            background: #f3f5f7;
            border-radius: 8px;
            padding: 12px 15px;
        }

        /* Etiqueta de cada dato */
        .etiqueta-sesion {
            color: #6c757d;
            font-size: 13px;
            display: block;
            margin-bottom: 3px;
        }

        /* Valor mostrado para cada dato */
        .valor-sesion {
            color: #263445;
            font-weight: 600;
        }

        /* Ajustes para pantallas pequeñas */
        @media (max-width: 768px) {
            .contenido-principal {
                width: 100%;
                margin: 20px auto;
                padding-left: 15px;
                padding-right: 15px;
            }

            /* Reduce el tamaño del nombre del sistema */
            .barra-superior .navbar-brand {
                font-size: 17px;
            }
        }
    </style>
</head>
<body>

    <!-- Menú principal del sistema -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Barra superior con el nombre del sistema y el usuario conectado -->
    <nav class="navbar navbar-dark barra-superior">
        <div class="container">
            <span class="navbar-brand">Conciliación Bancaria</span>

            <div class="d-flex align-items-center">
                <span class="text-white me-3">
                    Bienvenido, <strong><%= session.getAttribute("nombreUsuario") %></strong>
                </span>

                <!-- Botón para cerrar la sesión actual -->
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-light btn-sm">
                    Cerrar sesión
                </a>
            </div>
        </div>
    </nav>

    <!-- Contenido principal del Dashboard -->
    <div class="container contenido-principal">

        <!-- Título y descripción del Dashboard -->
        <h2 class="titulo-dashboard">
            Dashboard
        </h2>

        <p class="subtitulo-dashboard">
            Resumen general de la situación bancaria del sistema.
        </p>

        <!-- Tarjetas con el resumen de las operaciones bancarias -->
        <div class="row g-4">

            <!-- Total de cheques emitidos -->
            <div class="col-sm-6 col-xl-4">
                <div class="card tarjeta-estadistica">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Total de cheques emitidos
                        </div>

                        <!-- Valor obtenido desde el DashboardServlet -->
                        <div class="numero-estadistica text-primary">
                            <%= request.getAttribute("totalChequesEmitidos") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Cheques registrados en el sistema.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Total de cheques pendientes -->
            <div class="col-sm-6 col-xl-4">
                <div class="card tarjeta-estadistica tarjeta-pendiente">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Total de cheques pendientes
                        </div>

                        <!-- Cantidad de cheques que se encuentran pendientes -->
                        <div class="numero-estadistica text-warning">
                            <%= request.getAttribute("totalChequesPendientes") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Cheques que permanecen pendientes.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Total de cheques anulados -->
            <div class="col-sm-6 col-xl-4">
                <div class="card tarjeta-estadistica tarjeta-anulada">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Total de cheques anulados
                        </div>

                        <!-- Cantidad de cheques que fueron anulados -->
                        <div class="numero-estadistica text-danger">
                            <%= request.getAttribute("totalChequesAnulados") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Cheques registrados como anulados.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Total de depósitos -->
            <div class="col-sm-6 col-xl-4">
                <div class="card tarjeta-estadistica tarjeta-deposito">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Total de depósitos
                        </div>

                        <!-- Cantidad de depósitos registrados -->
                        <div class="numero-estadistica text-success">
                            <%= request.getAttribute("totalDepositos") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Depósitos registrados en el sistema.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Monto total de cheques -->
            <div class="col-sm-6 col-xl-4">
                <div class="card tarjeta-estadistica tarjeta-monto-cheque">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Monto total de cheques
                        </div>

                        <!-- Suma del valor de los cheques -->
                        <div class="monto-estadistica text-primary">
                            B/. <%= request.getAttribute("montoTotalCheques") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Valor acumulado de los cheques.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Monto total de depósitos -->
            <div class="col-sm-6 col-xl-4">
                <div class="card tarjeta-estadistica tarjeta-monto-deposito">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Monto total de depósitos
                        </div>

                        <!-- Suma del valor de los depósitos -->
                        <div class="monto-estadistica text-success">
                            B/. <%= request.getAttribute("montoTotalDepositos") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Valor acumulado de los depósitos.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Información de la última conciliación -->
            <div class="col-12">
                <div class="card tarjeta-estadistica tarjeta-conciliacion">
                    <div class="card-body">
                        <div class="titulo-estadistica">
                            Última conciliación realizada
                        </div>

                        <!-- Período de la última conciliación registrada -->
                        <div class="numero-estadistica">
                            <%= request.getAttribute("ultimaConciliacion") %>
                        </div>

                        <p class="descripcion-estadistica">
                            Período de la última conciliación registrada.
                        </p>
                    </div>
                </div>
            </div>

        </div>

        <!-- Información del usuario que inició sesión -->
        <div class="card tarjeta-sesion mt-5 mb-4">
            <div class="card-body">

                <h5 class="seccion-titulo mb-3">
                    Información de la sesión
                </h5>

                <div class="row g-3">

                    <!-- Nombre del usuario conectado -->
                    <div class="col-md-6">
                        <div class="dato-sesion">
                            <span class="etiqueta-sesion">
                                Usuario
                            </span>

                            <span class="valor-sesion">
                                <%= session.getAttribute("nombreUsuario") %>
                            </span>
                        </div>
                    </div>

                    <!-- Rol del usuario conectado -->
                    <div class="col-md-6">
                        <div class="dato-sesion">
                            <span class="etiqueta-sesion">
                                Rol
                            </span>

                            <span class="valor-sesion">
                                <%= session.getAttribute("rol") %>
                            </span>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</body>
</html>
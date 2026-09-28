<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.math.RoundingMode"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.DecimalFormatSymbols"%>
<%@ page import="java.time.YearMonth"%>
<%@ page import="java.time.format.TextStyle"%>
<%@ page import="java.util.Locale"%>

<%
    /*
     * Se utiliza un nombre diferente a "contexto" porque
     * menu.jsp ya declara una variable llamada contexto.
     */
    String contextoConciliacion = request.getContextPath();

    // Obtiene el período seleccionado desde el formulario.
    String periodo = request.getParameter("periodo");

    // Si no se recibió un período, se utiliza una cadena vacía.
    if (periodo == null) {
        periodo = "";
    }

    // Indica si ya existe una conciliación para el período consultado.
    boolean conciliacionExistente = Boolean.TRUE.equals(request.getAttribute("conciliacionExistente"));

    // Indica si se está visualizando una conciliación que ya fue registrada.
    boolean visualizarConciliacion = Boolean.TRUE.equals(request.getAttribute("visualizarConciliacion"));

    // Obtiene los mensajes enviados desde el servlet.
    String error = (String) request.getAttribute("error");
    String mensaje = (String) request.getAttribute("mensaje");

    /* =========================================================
       DATOS RECIBIDOS DESDE EL SERVLET
       ========================================================= */

    // Valores utilizados para construir la conciliación según libros.
    BigDecimal saldoInicial = (BigDecimal) request.getAttribute("saldoInicial");
    BigDecimal depositos = (BigDecimal) request.getAttribute("depositos");
    BigDecimal chequesAnulados = (BigDecimal) request.getAttribute("chequesAnulados");
    BigDecimal notasCredito = (BigDecimal) request.getAttribute("notasCredito");
    BigDecimal ajustesLibros = (BigDecimal) request.getAttribute("ajustesLibros");
    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal chequesGirados = (BigDecimal) request.getAttribute("chequesGirados");
    BigDecimal notasDebito = (BigDecimal) request.getAttribute("notasDebito");
    BigDecimal saldoConciliadoLibros = (BigDecimal) request.getAttribute("saldoConciliadoLibros");

    // Valores utilizados para construir la conciliación según banco.
    BigDecimal saldoBanco = (BigDecimal) request.getAttribute("saldoBanco");
    BigDecimal depositosTransito = (BigDecimal) request.getAttribute("depositosTransito");
    BigDecimal chequesCirculacion = (BigDecimal) request.getAttribute("chequesCirculacion");
    BigDecimal ajustesBanco = (BigDecimal) request.getAttribute("ajustesBanco");
    BigDecimal saldoConciliadoBanco = (BigDecimal) request.getAttribute("saldoConciliadoBanco");

    // Diferencia final entre ambos saldos conciliados.
    BigDecimal diferencia = (BigDecimal) request.getAttribute("diferencia");

    /* =========================================================
       EVITAR VALORES NULL
       ========================================================= */

    // Si algún valor no fue enviado por el servlet, se toma como cero.
    if (saldoInicial == null) saldoInicial = BigDecimal.ZERO;
    if (depositos == null) depositos = BigDecimal.ZERO;
    if (chequesAnulados == null) chequesAnulados = BigDecimal.ZERO;
    if (notasCredito == null) notasCredito = BigDecimal.ZERO;
    if (ajustesLibros == null) ajustesLibros = BigDecimal.ZERO;
    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (chequesGirados == null) chequesGirados = BigDecimal.ZERO;
    if (notasDebito == null) notasDebito = BigDecimal.ZERO;
    if (saldoConciliadoLibros == null) saldoConciliadoLibros = BigDecimal.ZERO;
    if (saldoBanco == null) saldoBanco = BigDecimal.ZERO;
    if (depositosTransito == null) depositosTransito = BigDecimal.ZERO;
    if (chequesCirculacion == null) chequesCirculacion = BigDecimal.ZERO;
    if (ajustesBanco == null) ajustesBanco = BigDecimal.ZERO;
    if (saldoConciliadoBanco == null) saldoConciliadoBanco = BigDecimal.ZERO;
    if (diferencia == null) diferencia = BigDecimal.ZERO;

    /* =========================================================
       FECHAS
       ========================================================= */

    // Estas variables almacenan las fechas que se mostrarán en el documento.
    String fechaInicioTexto = "";
    String fechaFinTexto = "";
    String nombrePeriodo = "";

    // Solo se calculan las fechas cuando existe un período válido.
    if (!periodo.isEmpty()) {
        try {
            // Convierte el período recibido, por ejemplo 2026-09, en un YearMonth.
            YearMonth mesActual = YearMonth.parse(periodo);

            // Obtiene el mes anterior al período seleccionado.
            YearMonth mesAnterior = mesActual.minusMonths(1);

            // Se utiliza español de Panamá para mostrar los nombres de los meses.
            Locale localePanama = new Locale("es", "PA");

            // Obtiene los nombres de ambos meses en mayúsculas.
            String nombreMesAnterior = mesAnterior.getMonth().getDisplayName(TextStyle.FULL, localePanama).toUpperCase();
            String nombreMesActual = mesActual.getMonth().getDisplayName(TextStyle.FULL, localePanama).toUpperCase();

            // Obtiene el último día de cada mes.
            int diaAnterior = mesAnterior.lengthOfMonth();
            int diaActual = mesActual.lengthOfMonth();

            // Construye las fechas que aparecen en el documento.
            fechaInicioTexto = diaAnterior + " DE " + nombreMesAnterior + " DE " + mesAnterior.getYear();
            fechaFinTexto = diaActual + " DE " + nombreMesActual + " DE " + mesActual.getYear();

            // Construye el nombre del período seleccionado.
            nombrePeriodo = nombreMesActual + " " + mesActual.getYear();

        } catch (Exception e) {
            // Si el período no tiene un formato válido, se dejan las fechas vacías.
            fechaInicioTexto = "";
            fechaFinTexto = "";
            nombrePeriodo = "";
        }
    }

    /* =========================================================
       FORMATO DE MONEDA
       ========================================================= */

    // Configura el formato de los valores monetarios.
    DecimalFormatSymbols simbolos = new DecimalFormatSymbols(Locale.US);
    DecimalFormat formato = new DecimalFormat("#,##0.00", simbolos);

    // Redondea los valores utilizando HALF_UP.
    formato.setRoundingMode(RoundingMode.HALF_UP);

    // Convierte los valores numéricos a texto para mostrarlos en el documento.
    String dineroInicial = formato.format(saldoInicial);
    String dineroDepositos = formato.format(depositos);
    String dineroAnulados = formato.format(chequesAnulados);
    String dineroNotasCredito = formato.format(notasCredito);
    String dineroAjustesLibros = formato.format(ajustesLibros);
    String dineroSubtotal = formato.format(subtotal);
    String dineroGirados = formato.format(chequesGirados);
    String dineroNotasDebito = formato.format(notasDebito);
    String dineroSaldoLibros = formato.format(saldoConciliadoLibros);
    String dineroBanco = formato.format(saldoBanco);
    String dineroDepositosTransito = formato.format(depositosTransito);
    String dineroCirculacion = formato.format(chequesCirculacion);
    String dineroAjustesBanco = formato.format(ajustesBanco);
    String dineroSaldoBanco = formato.format(saldoConciliadoBanco);
    String dineroDiferencia = formato.format(diferencia);

    /* =========================================================
       TOTALES
       ========================================================= */

    // Calcula los movimientos que aumentan el saldo según libros.
    BigDecimal totalMasLibros = depositos
            .add(chequesAnulados)
            .add(notasCredito)
            .add(ajustesLibros);

    // Calcula los movimientos que disminuyen el saldo según libros.
    BigDecimal totalMenosLibros = chequesGirados.add(notasDebito);

    // Calcula el ajuste que se aplica al saldo según banco.
    BigDecimal ajusteBanco = depositosTransito
            .subtract(chequesCirculacion)
            .add(ajustesBanco);

    // Formatea los totales para mostrarlos en pantalla.
    String dineroTotalMasLibros = formato.format(totalMasLibros);
    String dineroTotalMenosLibros = formato.format(totalMenosLibros);

    String dineroAjusteBanco;

    // Si el ajuste es negativo, se muestra entre paréntesis.
    if (ajusteBanco.compareTo(BigDecimal.ZERO) < 0) {
        dineroAjusteBanco = "(" + formato.format(ajusteBanco.abs()) + ")";
    } else {
        dineroAjusteBanco = formato.format(ajusteBanco);
    }

    /* =========================================================
       DATOS ESCRITOS POR EL USUARIO
       ========================================================= */

    // Obtiene los valores que el usuario había escrito en el formulario.
    String saldoBancoTexto = (String) request.getAttribute("saldoBancoTexto");
    String observacionesTexto = (String) request.getAttribute("observacionesTexto");

    // Evita mostrar valores null en los campos del formulario.
    if (saldoBancoTexto == null) {
        saldoBancoTexto = "";
    }

    if (observacionesTexto == null) {
        observacionesTexto = "";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>

    <!-- Configuración básica de la página -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Conciliación Bancaria</title>

    <!-- Bootstrap para los componentes y estilos de la página -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* Fondo general de la página */
        body {
            background: #f3f5f7;
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
        }

        /* Contenedor principal, teniendo en cuenta el menú lateral */
        .contenido-principal {
            margin-left: 70px;
            padding: 30px 35px;
        }

        /* Contenedor de las opciones de consulta */
        .acciones {
            max-width: 1450px;
            margin: 0 auto 20px auto;
        }

        /* Etiquetas del formulario de consulta */
        .acciones .form-label {
            color: #263445;
        }

        /* Campo para seleccionar el período */
        .acciones .form-control {
            border-radius: 8px;
            border: 1px solid #d6dce2;
        }

        /* Estilo del campo cuando está seleccionado */
        .acciones .form-control:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82, 109, 138, 0.15);
        }

        /* Botón para consultar un período */
        .boton-consultar {
            background: #3f6f9f;
            border: none;
            border-radius: 8px;
            padding: 9px 18px;
        }

        /* Cambio de color del botón al pasar el cursor */
        .boton-consultar:hover {
            background: #345d86;
        }

        /* Documento que representa visualmente la conciliación */
        .documento {
            background: #ffffff;
            border: none;
            border-radius: 14px;
            width: 100%;
            max-width: 1450px;
            margin: 20px auto;
            padding: 45px 55px 35px 55px;
            min-height: 720px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
        }

        /* Título principal de la conciliación */
        .titulo-periodo {
            text-align: center;
            font-weight: bold;
            font-size: 21px;
            margin-bottom: 40px;
            color: #263445;
        }

        /* Estructura de cada línea de la conciliación */
        .fila {
            display: grid;
            grid-template-columns: 1fr 240px 240px;
            align-items: center;
            min-height: 30px;
            font-size: 16px;
        }

        /* Estilo de las filas principales */
        .fila-principal {
            font-weight: bold;
            font-size: 17px;
            margin-top: 8px;
        }

        /* Alineación de las descripciones */
        .descripcion {
            text-align: left;
        }

        /* Primer nivel de indentación */
        .nivel-1 {
            padding-left: 45px;
        }

        /* Segundo nivel de indentación */
        .nivel-2 {
            padding-left: 100px;
        }

        /* Columna de movimientos */
        .monto-movimiento {
            width: 240px;
            text-align: right;
            font-variant-numeric: tabular-nums;
        }

        /* Columna de saldos */
        .monto-saldo {
            width: 240px;
            text-align: right;
            font-variant-numeric: tabular-nums;
        }

        /* Línea utilizada debajo de algunos valores */
        .monto-linea {
            border-bottom: 2px solid #777;
            padding-bottom: 4px;
        }

        /* Ajuste de espacio para los subtotales */
        .subtotal {
            margin-top: 4px;
        }

        /* Estilo de los resultados finales */
        .resultado {
            font-weight: bold;
            font-size: 17px;
            margin-top: 7px;
            padding-bottom: 5px;
        }

        /* Línea inferior del saldo final */
        .resultado .monto-saldo {
            border-bottom: 2px solid #777;
        }

        /* Sección correspondiente al saldo del banco */
        .seccion-banco {
            margin-top: 38px;
            padding-top: 25px;
            border-top: 1px solid #e1e5e9;
        }

        /* Contenedor del campo donde se introduce el saldo bancario */
        .campo-banco {
            width: 240px;
            margin-left: auto;
        }

        /* Campo para escribir el saldo del banco */
        .campo-banco input {
            width: 100%;
            text-align: right;
            font-size: 17px;
            border: 1px solid #ccd3da;
            border-radius: 8px;
            padding: 8px;
            box-sizing: border-box;
        }

        /* Estilo del campo de saldo cuando está seleccionado */
        .campo-banco input:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82, 109, 138, 0.15);
            outline: none;
        }

        /* Sección de observaciones */
        .observaciones {
            margin-top: 35px;
            padding-top: 25px;
            border-top: 1px solid #e1e5e9;
        }

        /* Campo para escribir las observaciones */
        .observaciones textarea {
            width: 100%;
            resize: vertical;
            border-radius: 8px;
            border: 1px solid #ccd3da;
        }

        /* Estilo del campo de observaciones cuando está seleccionado */
        .observaciones textarea:focus {
            border-color: #526d8a;
            box-shadow: 0 0 0 0.2rem rgba(82, 109, 138, 0.15);
            outline: none;
        }

        /* Alineación del botón para guardar */
        .boton-guardar {
            text-align: right;
            margin-top: 20px;
        }

        /* Estilo del botón de guardar */
        .boton-guardar .btn {
            border-radius: 8px;
            padding: 9px 18px;
        }

        /* Contenedor de las firmas */
        .firmas {
            display: flex;
            justify-content: space-around;
            gap: 80px;
            margin-top: 70px;
        }

        /* Espacio de cada firma */
        .firma {
            width: 260px;
            text-align: center;
        }

        /* Línea donde se coloca la firma */
        .linea-firma {
            border-top: 1px solid #555;
            padding-top: 5px;
        }

        /* Contenedor de los mensajes */
        .mensaje {
            max-width: 1450px;
            margin: 15px auto;
        }

        /* Estilo de las alertas */
        .mensaje .alert {
            border-radius: 10px;
            border: none;
        }

        /* Diseño general de los modales */
        .modal-content {
            border: none;
            border-radius: 14px;
            overflow: hidden;
        }

        /* Encabezado del modal */
        .modal-header {
            background: #263445;
            color: white;
        }

        /* Botón de cierre del modal */
        .modal-header .btn-close {
            filter: invert(1);
        }

        /* Pie del modal */
        .modal-footer {
            background: #f8f9fa;
        }

        /* Ajustes para pantallas medianas */
        @media (max-width: 1100px) {
            .contenido-principal {
                margin-left: 70px;
                padding: 25px;
            }

            .documento {
                padding: 35px 30px;
            }

            .fila {
                grid-template-columns: 1fr 190px 200px;
            }

            .monto-movimiento,
            .monto-saldo,
            .campo-banco {
                width: 190px;
            }
        }

        /* Ajustes para dispositivos pequeños */
        @media (max-width: 768px) {
            .contenido-principal {
                margin-left: 0;
                padding: 20px 15px;
            }

            /* Permite desplazar horizontalmente solamente el documento */
            .documento {
                padding: 30px 20px;
                overflow-x: auto;
            }

            .fila {
                grid-template-columns: minmax(280px, 1fr) 150px 170px;
                min-width: 650px;
            }

            .monto-movimiento,
            .monto-saldo,
            .campo-banco {
                width: 150px;
            }

            .campo-banco {
                margin-left: auto;
            }

            /* Las firmas se acomodan cuando no hay suficiente espacio */
            .firmas {
                justify-content: center;
                flex-wrap: wrap;
                gap: 50px;
            }
        }
    </style>
</head>

<body>

    <!-- Menú principal del sistema -->
    <%@ include file="../includes/menu.jsp" %>

    <!-- Contenido principal de la conciliación -->
    <div class="contenido-principal">

        <!-- Formulario para seleccionar el período que se desea consultar -->
        <div class="acciones">
            <form action="<%= contextoConciliacion %>/ConciliacionServlet" method="get" class="row g-3 align-items-end">

                <!-- Selección del mes y año -->
                <div class="col-md-5">
                    <label class="form-label fw-bold">
                        Seleccione el mes y año
                    </label>

                    <input type="month"
                           name="periodo"
                           class="form-control"
                           value="<%= periodo %>"
                           required>
                </div>

                <!-- Botón para realizar la consulta -->
                <div class="col-md-3">
                    <button type="submit" class="btn boton-consultar text-white">
                        Consultar
                    </button>
                </div>

            </form>
        </div>

        <!-- Mensaje de operación realizada correctamente -->
        <% if (mensaje != null) { %>
            <div class="mensaje">
                <div class="alert alert-success">
                    <%= mensaje %>
                </div>
            </div>
        <% } %>

        <!-- Mensaje de error enviado desde el servlet -->
        <% if (error != null) { %>
            <div class="mensaje">
                <div class="alert alert-danger">
                    <%= error %>
                </div>
            </div>
        <% } %>

        <!-- Solo se muestra el documento cuando existe un período seleccionado -->
        <% if (!periodo.isEmpty()) { %>

            <!-- Formulario utilizado para guardar la conciliación -->
            <form action="<%= contextoConciliacion %>/ConciliacionServlet" method="post">

                <!-- Indica al servlet que la acción solicitada es guardar -->
                <input type="hidden" name="accion" value="guardar">

                <!-- Mantiene el período seleccionado -->
                <input type="hidden" name="periodo" value="<%= periodo %>">

                <!-- Documento visual de la conciliación -->
                <div class="documento">

                    <!-- Título y período de la conciliación -->
                    <div class="titulo-periodo">
                        CONCILIACIÓN BANCARIA
                        <br>
                        <%= nombrePeriodo %>
                    </div>

                    <!-- SALDO SEGÚN LIBROS -->
                    <div class="fila fila-principal">
                        <div class="descripcion">
                            SALDO SEGÚN LIBRO AL <%= fechaInicioTexto %>
                        </div>

                        <div class="monto-movimiento"></div>

                        <div class="monto-saldo monto-linea">
                            <%= dineroInicial %>
                        </div>
                    </div>

                    <!-- Depósitos que aumentan el saldo -->
                    <div class="fila">
                        <div class="descripcion nivel-1">
                            Más: Depósitos
                        </div>

                        <div class="monto-movimiento">
                            <%= dineroDepositos %>
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Cheques anulados -->
                    <div class="fila">
                        <div class="descripcion nivel-2">
                            Cheques Anulados
                        </div>

                        <div class="monto-movimiento">
                            <%= dineroAnulados %>
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Notas de crédito -->
                    <div class="fila">
                        <div class="descripcion nivel-2">
                            Notas de Crédito
                        </div>

                        <div class="monto-movimiento">
                            <%= dineroNotasCredito %>
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Ajustes según libros -->
                    <div class="fila">
                        <div class="descripcion nivel-2">
                            Ajustes
                        </div>

                        <div class="monto-movimiento monto-linea">
                            <%= dineroAjustesLibros %>
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Subtotal de los movimientos según libros -->
                    <div class="fila">
                        <div class="descripcion">
                            <strong>SUBTOTAL</strong>
                        </div>

                        <div class="monto-movimiento"></div>

                        <div class="monto-saldo monto-linea">
                            <%= dineroSubtotal %>
                        </div>
                    </div>

                    <!-- Cheques girados que disminuyen el saldo -->
                    <div class="fila">
                        <div class="descripcion nivel-1">
                            Menos: Cheques Girados
                        </div>

                        <div class="monto-movimiento">
                            <%= dineroGirados %>
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Notas de débito -->
                    <div class="fila">
                        <div class="descripcion nivel-2">
                            Notas de Débito
                        </div>

                        <div class="monto-movimiento">
                            <%= dineroNotasDebito %>
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Ajustes según libros -->
                    <div class="fila">
                        <div class="descripcion nivel-2">
                            Ajustes
                        </div>

                        <div class="monto-movimiento monto-linea">
                            0.00
                        </div>

                        <div class="monto-saldo"></div>
                    </div>

                    <!-- Resultado final del saldo conciliado según libros -->
                    <div class="fila resultado">
                        <div class="descripcion">
                            SALDO CONCILIADO SEGÚN LIBROS AL <%= fechaFinTexto %>
                        </div>

                        <div class="monto-movimiento"></div>

                        <div class="monto-saldo">
                            <%= dineroSaldoLibros %>
                        </div>
                    </div>

                    <!-- Sección correspondiente a la conciliación según banco -->
                    <div class="seccion-banco">

                        <!-- Saldo informado por el banco -->
                        <div class="fila fila-principal">
                            <div class="descripcion">
                                SALDO EN BANCO AL <%= fechaFinTexto %>
                            </div>

                            <div class="monto-movimiento"></div>

                            <!-- Si ya existe y se está visualizando, se muestra el saldo guardado -->
                            <% if (conciliacionExistente && visualizarConciliacion) { %>

                                <div class="monto-saldo monto-linea">
                                    <%= dineroBanco %>
                                </div>

                            <% } else { %>

                                <!-- Si es una nueva conciliación, el usuario puede introducir el saldo -->
                                <div class="campo-banco">
                                    <input type="number"
                                           name="saldoBanco"
                                           autocomplete="off"
                                           step="0.01"
                                           min="0"
                                           value="<%= saldoBancoTexto %>"
                                           required>
                                </div>

                            <% } %>
                        </div>

                        <!-- Depósitos que todavía están en tránsito -->
                        <div class="fila">
                            <div class="descripcion nivel-1">
                                Más: Depósitos en Tránsito
                            </div>

                            <div class="monto-movimiento">
                                <%= dineroDepositosTransito %>
                            </div>

                            <div class="monto-saldo"></div>
                        </div>

                        <!-- Cheques que todavía están en circulación -->
                        <div class="fila">
                            <div class="descripcion nivel-1">
                                Menos: Cheques en Circulación
                            </div>

                            <div class="monto-movimiento">
                                <%= dineroCirculacion %>
                            </div>

                            <div class="monto-saldo"></div>
                        </div>

                        <!-- Ajustes realizados según el banco -->
                        <div class="fila">
                            <div class="descripcion nivel-1">
                                Más: Ajustes
                            </div>

                            <div class="monto-movimiento monto-linea">
                                <%= dineroAjustesBanco %>
                            </div>

                            <div class="monto-saldo"></div>
                        </div>

                        <!-- Muestra el resultado del ajuste bancario -->
                        <div class="fila">
                            <div class="descripcion"></div>

                            <div class="monto-movimiento monto-linea">
                                <%= dineroAjusteBanco %>
                            </div>

                            <div class="monto-saldo"></div>
                        </div>

                        <!-- Resultado final del saldo conciliado según banco -->
                        <div class="fila resultado">
                            <div class="descripcion">
                                SALDO CONCILIADO IGUAL A BANCO AL <%= fechaFinTexto %>
                            </div>

                            <div class="monto-movimiento"></div>

                            <div class="monto-saldo">
                                <%= dineroSaldoBanco %>
                            </div>
                        </div>

                    </div>

                    <!-- Campos que solamente aparecen cuando se puede guardar la conciliación -->
                    <% if (!conciliacionExistente || !visualizarConciliacion) { %>

                        <!-- Campo para agregar observaciones -->
                        <div class="observaciones">
                            <label class="form-label fw-bold">
                                Observaciones
                            </label>

                            <textarea name="observaciones"
                                      class="form-control"
                                      rows="3"><%= observacionesTexto %></textarea>
                        </div>

                        <!-- Botón para guardar la conciliación -->
                        <div class="boton-guardar">
                            <button type="submit" class="btn btn-success">
                                Guardar conciliación
                            </button>
                        </div>

                    <% } %>

                    <!-- Espacio destinado a las firmas -->
                    <div class="firmas">

                        <!-- Firma del contador -->
                        <div class="firma">
                            <div class="linea-firma">
                                Firma:
                            </div>

                            <strong>Verificador (Contador)</strong>
                        </div>

                        <!-- Firma del director -->
                        <div class="firma">
                            <div class="linea-firma">
                                Firma:
                            </div>

                            <strong>Revisado (Director)</strong>
                        </div>

                    </div>

                </div>
            </form>

        <% } %>

    </div>

    <!-- Modal que aparece cuando ya existe una conciliación para el período -->
    <% if (conciliacionExistente && !visualizarConciliacion) { %>

        <div class="modal fade show"
             id="modalConciliacion"
             tabindex="-1"
             style="display: block; background: rgba(0,0,0,.5);">

            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Conciliación Ya Registrada</h5>
                    </div>
                    <div class="modal-body">
                        <p class="mb-0">
                            Ya existe una conciliación bancaria guardada para el período <strong><%= periodo %></strong>.
                        </p>
                        <p class="text-muted small mt-2 mb-0">
                            ¿Desea visualizar el documento registrado previamente?
                        </p>
                    </div>
                    <div class="modal-footer">
                        <a href="<%= contextoConciliacion %>/ConciliacionServlet" class="btn btn-secondary">
                            Cancelar
                        </a>
                        <a href="<%= contextoConciliacion %>/ConciliacionServlet?periodo=<%= periodo %>&visualizar=1" class="btn btn-primary">
                            Visualizar Conciliación
                        </a>
                    </div>
                </div>
            </div>
        </div>

    <% } %>

</body>
</html>
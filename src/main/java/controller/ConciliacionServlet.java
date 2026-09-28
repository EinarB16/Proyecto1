package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.YearMonth;

import dao.BitacoraDAO;
import dao.ConciliacionDAO;
import model.Conciliacion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ConciliacionServlet")
public class ConciliacionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ConciliacionDAO conciliacionDAO = new ConciliacionDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // VERIFICAR SESIÓN
        // =====================================================

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/views/login.jsp"
            );

            return;
        }

        // =====================================================
        // MENSAJE DE GUARDADO
        // =====================================================

        String mensaje = request.getParameter("mensaje");

        if ("guardado".equals(mensaje)) {

            request.setAttribute(
                    "mensaje",
                    "La conciliación fue guardada correctamente."
            );
        }

        // =====================================================
        // OBTENER PERÍODO
        // =====================================================

        String periodo = request.getParameter("periodo");

        // =====================================================
        // SI NO HAY PERÍODO
        // =====================================================

        if (periodo == null || periodo.trim().isEmpty()) {

            request.getRequestDispatcher(
                    "/views/conciliacion.jsp"
            ).forward(request, response);

            return;
        }

        periodo = periodo.trim();

        // =====================================================
        // BUSCAR SI YA EXISTE UNA CONCILIACIÓN
        // =====================================================

        Conciliacion existente =
                conciliacionDAO.buscarPorPeriodo(periodo);

        // =====================================================
        // SI YA EXISTE
        // =====================================================

        if (existente != null) {

            request.setAttribute(
                    "conciliacion",
                    existente
            );

            request.setAttribute(
                    "conciliacionExistente",
                    true
            );

            boolean visualizar =
                    "1".equals(
                            request.getParameter("visualizar")
                    );

            request.setAttribute(
                    "visualizarConciliacion",
                    visualizar
            );

            /*
             * El saldo inicial del período actual es el
             * saldo conciliado según libros del período anterior.
             *
             * Ejemplo:
             * Enero 2025 = 27,842.05
             *
             * Entonces febrero inicia con:
             * 27,842.05
             */

            BigDecimal saldoInicial =
                    obtenerSaldoInicial(periodo);

            prepararDatosVista(
                    request,
                    periodo,
                    saldoInicial,
                    existente.getSaldoBanco()
            );
        }

        // =====================================================
        // NUEVA CONCILIACIÓN
        // =====================================================

        else {

            BigDecimal saldoInicial =
                    obtenerSaldoInicial(periodo);

            BigDecimal depositos =
                    conciliacionDAO.obtenerTotalDepositos(periodo);

            BigDecimal chequesAnulados =
                    conciliacionDAO.obtenerTotalChequesAnulados(periodo);

            BigDecimal chequesGirados =
                    conciliacionDAO.obtenerTotalChequesGirados(periodo);

            // La BD no maneja estos conceptos actualmente.
            BigDecimal notasCredito = BigDecimal.ZERO;
            BigDecimal ajustesLibros = BigDecimal.ZERO;
            BigDecimal notasDebito = BigDecimal.ZERO;
            BigDecimal ajustesBanco = BigDecimal.ZERO;

            // Actualmente no se manejan depósitos en tránsito.
            BigDecimal depositosTransito = BigDecimal.ZERO;

            // Cheques que realmente están en circulación al cierre.
            BigDecimal chequesCirculacion =
                    conciliacionDAO.obtenerTotalChequesCirculacion(periodo);

            // =================================================
            // PARTE DE LIBROS
            // =================================================

            BigDecimal totalMasLibros =
                    depositos
                    .add(chequesAnulados)
                    .add(notasCredito)
                    .add(ajustesLibros);

            BigDecimal subtotal =
                    saldoInicial
                    .add(totalMasLibros)
                    .setScale(2, RoundingMode.HALF_UP);

            BigDecimal totalMenosLibros =
                    chequesGirados
                    .add(notasDebito);

            BigDecimal saldoConciliadoLibros =
                    subtotal
                    .subtract(totalMenosLibros)
                    .setScale(2, RoundingMode.HALF_UP);

            // =================================================
            // PARTE DEL BANCO
            // =================================================

            /*
             * Todavía no se ha introducido el saldo bancario.
             *
             * Por eso NO calculamos:
             * 0.00 - chequesCirculacion
             *
             * porque eso produciría un número negativo
             * antes de que el usuario escriba el saldo.
             */

            BigDecimal saldoBanco = null;
            BigDecimal saldoConciliadoBanco = null;
            BigDecimal diferencia = null;

            colocarDatosRequest(
                    request,
                    saldoInicial,
                    depositos,
                    chequesAnulados,
                    notasCredito,
                    ajustesLibros,
                    subtotal,
                    chequesGirados,
                    notasDebito,
                    saldoConciliadoLibros,
                    saldoBanco,
                    depositosTransito,
                    chequesCirculacion,
                    ajustesBanco,
                    saldoConciliadoBanco,
                    diferencia
            );

            request.setAttribute(
                    "conciliacionExistente",
                    false
            );

            request.setAttribute(
                    "visualizarConciliacion",
                    false
            );
        }

        // =====================================================
        // MOSTRAR JSP
        // =====================================================

        request.getRequestDispatcher(
                "/views/conciliacion.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("usuario") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/views/login.jsp"
            );

            return;
        }

        request.setCharacterEncoding("UTF-8");

        String accion =
                request.getParameter("accion");

        if ("guardar".equals(accion)) {

            guardarConciliacion(
                    request,
                    response
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ConciliacionServlet"
            );
        }
    }

    // =========================================================
    // GUARDAR CONCILIACIÓN
    // =========================================================

    private void guardarConciliacion(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String periodo =
                    request.getParameter("periodo");

            String saldoBancoTexto =
                    request.getParameter("saldoBanco");

            String observaciones =
                    request.getParameter("observaciones");

            // =================================================
            // VALIDAR PERÍODO
            // =================================================

            if (periodo == null ||
                periodo.trim().isEmpty()) {

                mostrarError(
                        request,
                        response,
                        "Debe seleccionar un período."
                );

                return;
            }

            periodo = periodo.trim();

            // =================================================
            // EVITAR DUPLICADOS
            // =================================================

            Conciliacion existente =
                    conciliacionDAO.buscarPorPeriodo(periodo);

            if (existente != null) {

                mostrarError(
                        request,
                        response,
                        "Ya existe una conciliación bancaria registrada para el período "
                        + periodo + "."
                );

                return;
            }

            // =================================================
            // VALIDAR SALDO BANCO
            // =================================================

            if (saldoBancoTexto == null ||
                saldoBancoTexto.trim().isEmpty()) {

                mostrarError(
                        request,
                        response,
                        "El saldo según banco es obligatorio."
                );

                return;
            }

            BigDecimal saldoBanco;

            try {

                saldoBanco =
                        new BigDecimal(
                                saldoBancoTexto.trim()
                        );

            } catch (NumberFormatException e) {

                mostrarError(
                        request,
                        response,
                        "El saldo según banco debe ser un número válido."
                );

                return;
            }

            if (saldoBanco.compareTo(BigDecimal.ZERO) < 0) {

                mostrarError(
                        request,
                        response,
                        "El saldo según banco no puede ser negativo."
                );

                return;
            }

            saldoBanco =
                    saldoBanco.setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            // =================================================
            // DATOS DEL PERÍODO
            // =================================================

            BigDecimal saldoInicial =
                    obtenerSaldoInicial(periodo);

            BigDecimal depositos =
                    conciliacionDAO.obtenerTotalDepositos(periodo);

            BigDecimal chequesAnulados =
                    conciliacionDAO.obtenerTotalChequesAnulados(periodo);

            BigDecimal chequesGirados =
                    conciliacionDAO.obtenerTotalChequesGirados(periodo);

            BigDecimal notasCredito =
                    BigDecimal.ZERO;

            BigDecimal ajustesLibros =
                    BigDecimal.ZERO;

            BigDecimal notasDebito =
                    BigDecimal.ZERO;

            BigDecimal ajustesBanco =
                    BigDecimal.ZERO;

            BigDecimal depositosTransito =
                    BigDecimal.ZERO;

            BigDecimal chequesCirculacion =
                    conciliacionDAO.obtenerTotalChequesCirculacion(periodo);

            // =================================================
            // LIBROS
            // =================================================

            BigDecimal totalMasLibros =
                    depositos
                    .add(chequesAnulados)
                    .add(notasCredito)
                    .add(ajustesLibros);

            BigDecimal subtotal =
                    saldoInicial
                    .add(totalMasLibros)
                    .setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            BigDecimal totalMenosLibros =
                    chequesGirados
                    .add(notasDebito);

            /*
             * Este es el saldo que debe guardarse como
             * saldo_libros de la conciliación actual.
             *
             * Ejemplo febrero:
             * 27,842.05 - 2,114.08 = 25,727.97
             */

            BigDecimal saldoConciliadoLibros =
                    subtotal
                    .subtract(totalMenosLibros)
                    .setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            // =================================================
            // BANCO
            // =================================================

            /*
             * Saldo banco
             * + depósitos en tránsito
             * - cheques en circulación
             * + ajustes
             */

            BigDecimal ajusteBanco =
                    depositosTransito
                    .subtract(chequesCirculacion)
                    .add(ajustesBanco);

            BigDecimal saldoConciliadoBanco =
                    saldoBanco
                    .add(ajusteBanco)
                    .setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            // =================================================
            // DIFERENCIA
            // =================================================

            BigDecimal diferencia =
                    saldoConciliadoLibros
                    .subtract(saldoConciliadoBanco)
                    .setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            // =================================================
            // SOLO GUARDAR SI LA DIFERENCIA ES 0.00
            // =================================================

            if (diferencia.compareTo(BigDecimal.ZERO) != 0) {

                colocarDatosRequest(
                        request,
                        saldoInicial,
                        depositos,
                        chequesAnulados,
                        notasCredito,
                        ajustesLibros,
                        subtotal,
                        chequesGirados,
                        notasDebito,
                        saldoConciliadoLibros,
                        saldoBanco,
                        depositosTransito,
                        chequesCirculacion,
                        ajustesBanco,
                        saldoConciliadoBanco,
                        diferencia
                );

                request.setAttribute(
                        "saldoBancoTexto",
                        saldoBancoTexto
                );

                request.setAttribute(
                        "observacionesTexto",
                        observaciones
                );

                request.setAttribute(
                        "conciliacionExistente",
                        false
                );

                request.setAttribute(
                        "visualizarConciliacion",
                        false
                );

                request.setAttribute(
                        "error",
                        "La conciliación no puede guardarse porque la diferencia es B/. "
                        + diferencia.toPlainString()
                        + ". Debe ser B/. 0.00."
                );

                request.getRequestDispatcher(
                        "/views/conciliacion.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            // =================================================
            // OBTENER USUARIO
            // =================================================

            HttpSession session =
                    request.getSession(false);

            Integer idUsuario =
                    (Integer) session.getAttribute("idUsuario");

            if (idUsuario == null) {

                mostrarError(
                        request,
                        response,
                        "No se pudo identificar al usuario."
                );

                return;
            }

            // =================================================
            // CREAR OBJETO
            // =================================================

            Conciliacion conciliacion =
                    new Conciliacion();

            conciliacion.setPeriodo(periodo);

            /*
             * IMPORTANTE:
             * Aquí NO guardamos saldoInicial.
             * Guardamos el saldo conciliado según libros del período actual.
             *
             * Ejemplo:
             * Febrero = 25,727.97
             * Ese será el saldo inicial que utilizará marzo.
             */

            conciliacion.setSaldoLibros(
                    saldoConciliadoLibros
            );

            conciliacion.setDepositosTransito(
                    depositosTransito
            );

            /*
             * Se guardan los cheques en circulación
             * al cierre del período.
             */

            conciliacion.setChequesPendientes(
                    chequesCirculacion
            );

            conciliacion.setSaldoBanco(
                    saldoBanco
            );

            conciliacion.setDiferencia(
                    diferencia
            );

            /*
             * 3 = Verificada.
             */

            conciliacion.setEstado(3);

            conciliacion.setIdUsuario(
                    idUsuario
            );

            conciliacion.setObservaciones(
                    observaciones
            );

            // =================================================
            // INSERTAR
            // =================================================

            boolean guardado =
                    conciliacionDAO.insertar(
                            conciliacion
                    );

            if (guardado) {

                // =================================================
                // BITÁCORA
                // =================================================

                bitacoraDAO.registrarAccion(
                        idUsuario,
                        "INSERT",
                        "conciliaciones",
                        "Se registró una conciliación bancaria para el período "
                        + periodo
                        + " con saldo según banco de B/. "
                        + saldoBanco.toPlainString()
                );

                // =================================================
                // REDIRECCIÓN
                // =================================================

                String periodoCodificado =
                        URLEncoder.encode(
                                periodo,
                                StandardCharsets.UTF_8
                        );

                response.sendRedirect(
                        request.getContextPath()
                        + "/ConciliacionServlet?periodo="
                        + periodoCodificado
                        + "&mensaje=guardado"
                );

            } else {

                mostrarError(
                        request,
                        response,
                        "No se pudo guardar la conciliación."
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            mostrarError(
                    request,
                    response,
                    "Ocurrió un error al procesar la conciliación."
            );
        }
    }

    // =========================================================
    // OBTENER SALDO INICIAL
    // =========================================================

    private BigDecimal obtenerSaldoInicial(String periodo) {

        try {

            // Convertimos el período actual a Año-Mes
            YearMonth mesActual =
                    YearMonth.parse(periodo);

            // Obtenemos el mes anterior
            YearMonth mesAnterior =
                    mesActual.minusMonths(1);

            String periodoAnterior =
                    mesAnterior.toString();

            // Buscamos la conciliación del mes anterior
            Conciliacion anterior =
                    conciliacionDAO.buscarPorPeriodo(
                            periodoAnterior
                    );

            /*
             * Si no existe conciliación anterior,
             * no tenemos un saldo inicial registrado.
             */
            if (anterior == null ||
                anterior.getSaldoLibros() == null) {

                return BigDecimal.ZERO;
            }

            return anterior.getSaldoLibros();

        } catch (Exception e) {

            System.out.println(
                    "Error al obtener el saldo inicial:"
            );

            e.printStackTrace();

            return BigDecimal.ZERO;
        }
    }

    // =========================================================
    // PREPARAR DATOS PARA EL JSP
    // =========================================================

    private void prepararDatosVista(
            HttpServletRequest request,
            String periodo,
            BigDecimal saldoInicial,
            BigDecimal saldoBanco) {

        if (saldoInicial == null) {

            saldoInicial =
                    BigDecimal.ZERO;
        }

        BigDecimal depositos =
                conciliacionDAO.obtenerTotalDepositos(periodo);

        BigDecimal chequesAnulados =
                conciliacionDAO.obtenerTotalChequesAnulados(periodo);

        BigDecimal chequesGirados =
                conciliacionDAO.obtenerTotalChequesGirados(periodo);

        BigDecimal notasCredito =
                BigDecimal.ZERO;

        BigDecimal ajustesLibros =
                BigDecimal.ZERO;

        BigDecimal notasDebito =
                BigDecimal.ZERO;

        BigDecimal depositosTransito =
                BigDecimal.ZERO;

        BigDecimal chequesCirculacion =
                conciliacionDAO.obtenerTotalChequesCirculacion(
                        periodo
                );

        BigDecimal ajustesBanco =
                BigDecimal.ZERO;

        // =====================================================
        // LIBROS
        // =====================================================

        BigDecimal totalMas =
                depositos
                .add(chequesAnulados)
                .add(notasCredito)
                .add(ajustesLibros);

        BigDecimal subtotal =
                saldoInicial
                .add(totalMas)
                .setScale(
                        2,
                        RoundingMode.HALF_UP
                );

        BigDecimal totalMenos =
                chequesGirados
                .add(notasDebito);

        BigDecimal saldoConciliadoLibros =
                subtotal
                .subtract(totalMenos)
                .setScale(
                        2,
                        RoundingMode.HALF_UP
                );

        // =====================================================
        // BANCO
        // =====================================================

        BigDecimal saldoConciliadoBanco = null;
        BigDecimal diferencia = null;

        if (saldoBanco != null) {

            /*
             * El saldo conciliado según banco se obtiene
             * tomando el saldo del banco y aplicando los
             * ajustes correspondientes.
             *
             * Ejemplo:
             * Saldo en banco       27,675.33
             * Depósitos en tránsito     0.00
             * Cheques en circulación  -1,947.36
             * Ajustes                   0.00
             *
             * Resultado             25,727.97
             */

            BigDecimal ajusteBanco =
                    depositosTransito
                    .subtract(chequesCirculacion)
                    .add(ajustesBanco);

            saldoConciliadoBanco =
                    saldoBanco
                    .add(ajusteBanco)
                    .setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            /*
             * La diferencia debe comparar:
             * Saldo conciliado según libros
             * -
             * Saldo conciliado igual a banco
             */

            diferencia =
                    saldoConciliadoLibros
                    .subtract(saldoConciliadoBanco)
                    .setScale(
                            2,
                            RoundingMode.HALF_UP
                    );
        }

        // =====================================================
        // ENVIAR DATOS AL JSP
        // =====================================================

        colocarDatosRequest(
                request,
                saldoInicial,
                depositos,
                chequesAnulados,
                notasCredito,
                ajustesLibros,
                subtotal,
                chequesGirados,
                notasDebito,
                saldoConciliadoLibros,
                saldoBanco,
                depositosTransito,
                chequesCirculacion,
                ajustesBanco,
                saldoConciliadoBanco,
                diferencia
        );
    }

    // =========================================================
    // COLOCAR DATOS EN REQUEST
    // =========================================================

    private void colocarDatosRequest(
            HttpServletRequest request,
            BigDecimal saldoInicial,
            BigDecimal depositos,
            BigDecimal chequesAnulados,
            BigDecimal notasCredito,
            BigDecimal ajustesLibros,
            BigDecimal subtotal,
            BigDecimal chequesGirados,
            BigDecimal notasDebito,
            BigDecimal saldoConciliadoLibros,
            BigDecimal saldoBanco,
            BigDecimal depositosTransito,
            BigDecimal chequesCirculacion,
            BigDecimal ajustesBanco,
            BigDecimal saldoConciliadoBanco,
            BigDecimal diferencia) {

        request.setAttribute(
                "saldoInicial",
                saldoInicial
        );

        request.setAttribute(
                "depositos",
                depositos
        );

        request.setAttribute(
                "chequesAnulados",
                chequesAnulados
        );

        request.setAttribute(
                "notasCredito",
                notasCredito
        );

        request.setAttribute(
                "ajustesLibros",
                ajustesLibros
        );

        request.setAttribute(
                "subtotal",
                subtotal
        );

        request.setAttribute(
                "chequesGirados",
                chequesGirados
        );

        request.setAttribute(
                "notasDebito",
                notasDebito
        );

        request.setAttribute(
                "saldoConciliadoLibros",
                saldoConciliadoLibros
        );

        request.setAttribute(
                "saldoBanco",
                saldoBanco
        );

        request.setAttribute(
                "depositosTransito",
                depositosTransito
        );

        request.setAttribute(
                "chequesCirculacion",
                chequesCirculacion
        );

        request.setAttribute(
                "ajustesBanco",
                ajustesBanco
        );

        request.setAttribute(
                "saldoConciliadoBanco",
                saldoConciliadoBanco
        );

        request.setAttribute(
                "diferencia",
                diferencia
        );
    }

    // =========================================================
    // MOSTRAR ERROR
    // =========================================================

    private void mostrarError(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje)
            throws ServletException, IOException {

        request.setAttribute(
                "error",
                mensaje
        );

        request.getRequestDispatcher(
                "/views/conciliacion.jsp"
        ).forward(
                request,
                response
        );
    }
}
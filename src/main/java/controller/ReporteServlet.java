package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.ChequeDAO;
import dao.DepositoDAO;
import dao.ConciliacionDAO;
import dao.ProveedorDAO;

import model.Cheque;
import model.Deposito;
import model.Conciliacion;
import model.Proveedor;

@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ChequeDAO chequeDAO;
    private DepositoDAO depositoDAO;
    private ConciliacionDAO conciliacionDAO;
    private ProveedorDAO proveedorDAO;

    @Override
    public void init() throws ServletException {

        chequeDAO = new ChequeDAO();
        depositoDAO = new DepositoDAO();
        conciliacionDAO = new ConciliacionDAO();
        proveedorDAO = new ProveedorDAO();

    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String tipo = request.getParameter("tipo");

        try {

            /*
             * Siempre cargamos los proveedores activos.
             * Esto permite que el desplegable de proveedores
             * aparezca tanto al abrir la página como al buscar cheques.
             */
            List<Proveedor> proveedoresActivos =
                    proveedorDAO.listarActivos();

            request.setAttribute(
                    "proveedoresActivos",
                    proveedoresActivos
            );


            /*
             * Si no se indicó ningún tipo de consulta,
             * solamente se abre la página principal de reportes.
             */
            if (tipo == null || tipo.trim().isEmpty()) {

                request.getRequestDispatcher(
                        "/views/reportes.jsp"
                ).forward(request, response);

                return;
            }


            // =====================================================
            // CONSULTA DE CHEQUES
            // =====================================================

            if ("cheques".equals(tipo)) {

                String fechaInicial =
                        request.getParameter("fechaInicial");

                String fechaFinal =
                        request.getParameter("fechaFinal");

                String numeroCheque =
                        request.getParameter("numeroCheque");

                String proveedor =
                        request.getParameter("proveedor");

                String estado =
                        request.getParameter("estado");


                /*
                 * Se ejecuta la búsqueda utilizando los filtros
                 * recibidos desde el formulario del modal.
                 */
                List<Cheque> cheques =
                        chequeDAO.buscarConFiltros(
                                fechaInicial,
                                fechaFinal,
                                numeroCheque,
                                proveedor,
                                estado
                        );


                request.setAttribute(
                        "cheques",
                        cheques
                );

                /*
                 * Este atributo permite que, después de buscar,
                 * el modal de cheques vuelva a abrirse automáticamente.
                 */
                request.setAttribute(
                        "modalActivo",
                        "modalCheques"
                );


                request.getRequestDispatcher(
                        "/views/reportes.jsp"
                ).forward(request, response);

                return;
            }


            // =====================================================
            // CONSULTA DE DEPÓSITOS
            // =====================================================

            if ("depositos".equals(tipo)) {

                String fechaInicial =
                        request.getParameter("fechaInicial");

                String fechaFinal =
                        request.getParameter("fechaFinal");

                String numeroComprobante =
                        request.getParameter("numeroComprobante");

                String tipoDeposito =
                        request.getParameter("tipoDeposito");

                String estado =
                        request.getParameter("estado");


                List<Deposito> depositos =
                        depositoDAO.buscarConFiltros(
                                fechaInicial,
                                fechaFinal,
                                numeroComprobante,
                                tipoDeposito
                        );


                /*
                 * El método actual del DAO no recibe estado,
                 * por eso se filtra aquí después de obtener los datos.
                 */
                if (estado != null && !estado.trim().isEmpty()) {

                    int estadoBuscado =
                            Integer.parseInt(estado.trim());

                    List<Deposito> depositosFiltrados =
                            new ArrayList<>();

                    for (Deposito deposito : depositos) {

                        if (deposito.getEstado() == estadoBuscado) {

                            depositosFiltrados.add(deposito);

                        }

                    }

                    depositos = depositosFiltrados;

                }


                /*
                 * Calculamos el total de los depósitos encontrados.
                 */
                BigDecimal totalDepositos =
                        BigDecimal.ZERO;

                for (Deposito deposito : depositos) {

                    totalDepositos =
                            totalDepositos.add(
                                    BigDecimal.valueOf(
                                            deposito.getMonto()
                                    )
                            );

                }


                request.setAttribute(
                        "depositos",
                        depositos
                );

                request.setAttribute(
                        "totalDepositos",
                        totalDepositos
                );

                request.setAttribute(
                        "modalActivo",
                        "modalDepositos"
                );


                request.getRequestDispatcher(
                        "/views/reportes.jsp"
                ).forward(request, response);

                return;
            }


            // =====================================================
            // CONSULTA DE CONCILIACIONES
            // =====================================================

            if ("conciliaciones".equals(tipo)) {

                String mes =
                        request.getParameter("mes");

                String anio =
                        request.getParameter("anio");


                List<Conciliacion> conciliaciones =
                        conciliacionDAO.listarTodos();


                /*
                 * Si se seleccionó mes o año, filtramos
                 * las conciliaciones por su período.
                 */
                if ((mes != null && !mes.trim().isEmpty())
                        || (anio != null && !anio.trim().isEmpty())) {

                    List<Conciliacion> conciliacionesFiltradas =
                            new ArrayList<>();

                    for (Conciliacion conciliacion : conciliaciones) {

                        String periodo =
                                conciliacion.getPeriodo();

                        if (periodo == null) {
                            continue;
                        }

                        boolean coincide = true;


                        if (anio != null && !anio.trim().isEmpty()) {

                            if (!periodo.startsWith(
                                    anio.trim() + "-"
                            )) {

                                coincide = false;

                            }

                        }


                        if (mes != null && !mes.trim().isEmpty()) {

                            if (!periodo.endsWith(
                                    "-" + mes.trim()
                            )) {

                                coincide = false;

                            }

                        }


                        if (coincide) {

                            conciliacionesFiltradas.add(
                                    conciliacion
                            );

                        }

                    }

                    conciliaciones =
                            conciliacionesFiltradas;

                }


                request.setAttribute(
                        "conciliaciones",
                        conciliaciones
                );

                request.setAttribute(
                        "modalActivo",
                        "modalConciliaciones"
                );


                request.getRequestDispatcher(
                        "/views/reportes.jsp"
                ).forward(request, response);

                return;
            }


            /*
             * Si se recibe un tipo de consulta desconocido,
             * se vuelve a la página principal.
             */
            request.getRequestDispatcher(
                    "/views/reportes.jsp"
            ).forward(request, response);


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Ocurrió un error al generar la consulta: "
                            + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/views/reportes.jsp"
            ).forward(request, response);

        }

    }

}
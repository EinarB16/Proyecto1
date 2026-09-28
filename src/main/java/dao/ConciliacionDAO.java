package dao;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import config.Conexion;
import model.Conciliacion;

public class ConciliacionDAO {

    // =========================================================
    // INSERTAR CONCILIACIÓN
    // =========================================================

    public boolean insertar(Conciliacion conciliacion) {

        String sqlId =
                "SELECT COALESCE(MAX(id_conciliacion), 0) + 1 " +
                "FROM conciliaciones";

        String sqlConciliacion =
                "INSERT INTO conciliaciones " +
                "(id_conciliacion, periodo, saldo_libros, " +
                "depositos_transito, cheques_pendientes, saldo_banco, " +
                "diferencia, estado, id_usuario, observaciones) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlDepositos =
                "SELECT id_deposito, monto " +
                "FROM depositos " +
                "WHERE estado = 1 " +
                "AND DATE_FORMAT(fecha, '%Y-%m') = ?";

        /*
         * Los cheques se guardan según el estado que tenían
         * al cierre del período.
         */
        String sqlCheques =
                "SELECT c.id_cheque, c.monto " +
                "FROM cheques c " +
                "WHERE c.fecha_cheque <= LAST_DAY(CONCAT(?, '-01')) " +
                "AND COALESCE( " +
                "    ( " +
                "        SELECT h.estado_nuevo " +
                "        FROM historial_cheque h " +
                "        WHERE h.id_cheque = c.id_cheque " +
                "        AND h.fecha_cambio <= LAST_DAY(CONCAT(?, '-01')) " +
                "        ORDER BY h.fecha_cambio DESC, h.id_historial DESC " +
                "        LIMIT 1 " +
                "    ), " +
                "    2 " +
                ") = 2";

        String sqlDetalleDeposito =
                "INSERT INTO conciliacion_detalle_deposito " +
                "(id_conciliacion, id_deposito, monto_al_momento) " +
                "VALUES (?, ?, ?)";

        String sqlDetalleCheque =
                "INSERT INTO conciliacion_detalle_cheque " +
                "(id_conciliacion, id_cheque, monto_al_momento) " +
                "VALUES (?, ?, ?)";

        Connection conexion = null;

        try {

            conexion = Conexion.conectar();

            conexion.setAutoCommit(false);

            // =================================================
            // OBTENER SIGUIENTE ID
            // =================================================

            int siguienteId = 1;

            try (
                    PreparedStatement psId =
                            conexion.prepareStatement(sqlId);
                    ResultSet rs =
                            psId.executeQuery()
            ) {

                if (rs.next()) {
                    siguienteId = rs.getInt(1);
                }
            }

            // =================================================
            // INSERTAR CONCILIACIÓN
            // =================================================

            try (
                    PreparedStatement ps =
                            conexion.prepareStatement(sqlConciliacion)
            ) {

                ps.setInt(1, siguienteId);

                ps.setString(
                        2,
                        conciliacion.getPeriodo()
                );

                ps.setBigDecimal(
                        3,
                        conciliacion.getSaldoLibros()
                );

                ps.setBigDecimal(
                        4,
                        conciliacion.getDepositosTransito()
                );

                ps.setBigDecimal(
                        5,
                        conciliacion.getChequesPendientes()
                );

                ps.setBigDecimal(
                        6,
                        conciliacion.getSaldoBanco()
                );

                ps.setBigDecimal(
                        7,
                        conciliacion.getDiferencia()
                );

                /*
                 * 3 = Verificada.
                 *
                 * Solo llega aquí una conciliación con
                 * diferencia igual a 0.00.
                 */

                if (conciliacion.getDiferencia()
                        .compareTo(BigDecimal.ZERO) == 0) {

                    ps.setInt(8, 3);

                } else {

                    ps.setInt(
                            8,
                            conciliacion.getEstado()
                    );
                }

                ps.setInt(
                        9,
                        conciliacion.getIdUsuario()
                );

                ps.setString(
                        10,
                        conciliacion.getObservaciones()
                );

                int filas = ps.executeUpdate();

                if (filas == 0) {

                    conexion.rollback();

                    return false;
                }
            }

            conciliacion.setIdConciliacion(siguienteId);

            // =================================================
            // DETALLE DE DEPÓSITOS
            // =================================================

            try (
                    PreparedStatement psDepositos =
                            conexion.prepareStatement(sqlDepositos);

                    PreparedStatement psDetalle =
                            conexion.prepareStatement(
                                    sqlDetalleDeposito
                            )
            ) {

                psDepositos.setString(
                        1,
                        conciliacion.getPeriodo()
                );

                try (
                        ResultSet rs =
                                psDepositos.executeQuery()
                ) {

                    while (rs.next()) {

                        int idDeposito =
                                rs.getInt("id_deposito");

                        BigDecimal monto =
                                rs.getBigDecimal("monto");

                        psDetalle.setInt(
                                1,
                                siguienteId
                        );

                        psDetalle.setInt(
                                2,
                                idDeposito
                        );

                        psDetalle.setBigDecimal(
                                3,
                                monto
                        );

                        psDetalle.addBatch();
                    }
                }

                psDetalle.executeBatch();
            }

            // =================================================
            // DETALLE DE CHEQUES EN CIRCULACIÓN
            // =================================================

            try (
                    PreparedStatement psCheques =
                            conexion.prepareStatement(sqlCheques);

                    PreparedStatement psDetalle =
                            conexion.prepareStatement(
                                    sqlDetalleCheque
                            )
            ) {

                psCheques.setString(
                        1,
                        conciliacion.getPeriodo()
                );

                psCheques.setString(
                        2,
                        conciliacion.getPeriodo()
                );

                try (
                        ResultSet rs =
                                psCheques.executeQuery()
                ) {

                    while (rs.next()) {

                        int idCheque =
                                rs.getInt("id_cheque");

                        BigDecimal monto =
                                rs.getBigDecimal("monto");

                        psDetalle.setInt(
                                1,
                                siguienteId
                        );

                        psDetalle.setInt(
                                2,
                                idCheque
                        );

                        psDetalle.setBigDecimal(
                                3,
                                monto
                        );

                        psDetalle.addBatch();
                    }
                }

                psDetalle.executeBatch();
            }

            conexion.commit();

            return true;

        } catch (SQLException e) {

            if (conexion != null) {

                try {
                    conexion.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            System.out.println(
                    "Error al insertar la conciliación:"
            );

            e.printStackTrace();

            return false;

        } finally {

            if (conexion != null) {

                try {

                    conexion.setAutoCommit(true);
                    conexion.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }

    // =========================================================
    // LISTAR TODAS LAS CONCILIACIONES
    // =========================================================

    public List<Conciliacion> listarTodos() {

        List<Conciliacion> lista =
                new ArrayList<>();

        String sql =
                "SELECT * FROM conciliaciones " +
                "ORDER BY fecha_conciliacion DESC";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql);

                ResultSet rs =
                        ps.executeQuery()
        ) {

            while (rs.next()) {

                lista.add(
                        convertirResultado(rs)
                );
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al listar las conciliaciones:"
            );

            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // BUSCAR POR PERÍODO
    // =========================================================

    public Conciliacion buscarPorPeriodo(
            String periodo) {

        String sql =
                "SELECT * FROM conciliaciones " +
                "WHERE periodo = ?";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    return convertirResultado(rs);
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al buscar la conciliación:"
            );

            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // BUSCAR ÚLTIMA CONCILIACIÓN ANTERIOR
    // =========================================================

    public Conciliacion buscarUltimaAntesDe(
            String periodo) {

        String sql =
                "SELECT * FROM conciliaciones " +
                "WHERE periodo < ? " +
                "ORDER BY periodo DESC " +
                "LIMIT 1";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    return convertirResultado(rs);
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al buscar la conciliación anterior:"
            );

            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // DEPÓSITOS DEL PERÍODO
    // =========================================================

    public BigDecimal obtenerTotalDepositos(
            String periodo) {

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM depositos " +
                "WHERE estado = 1 " +
                "AND DATE_FORMAT(fecha, '%Y-%m') = ?";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    BigDecimal total =
                            rs.getBigDecimal("total");

                    return total != null
                            ? total
                            : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al obtener los depósitos:"
            );

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================================================
    // CHEQUES ANULADOS DEL PERÍODO
    // =========================================================

    public BigDecimal obtenerTotalChequesAnulados(
            String periodo) {

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM cheques " +
                "WHERE fecha_anulacion IS NOT NULL " +
                "AND DATE_FORMAT(fecha_anulacion, '%Y-%m') = ?";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    BigDecimal total =
                            rs.getBigDecimal("total");

                    return total != null
                            ? total
                            : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al obtener los cheques anulados:"
            );

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================================================
    // CHEQUES GIRADOS DEL PERÍODO
    // =========================================================

    public BigDecimal obtenerTotalChequesGirados(
            String periodo) {

        /*
         * Son los cheques emitidos durante el período.
         *
         * Si fueron anulados antes del cierre,
         * no forman parte de los cheques girados.
         *
         * El historial permite conocer el estado que tenían
         * al cierre del período.
         */

        String sql =
                "SELECT COALESCE(SUM(c.monto), 0) AS total " +
                "FROM cheques c " +
                "WHERE DATE_FORMAT(c.fecha_cheque, '%Y-%m') = ? " +
                "AND COALESCE( " +
                "    ( " +
                "        SELECT h.estado_nuevo " +
                "        FROM historial_cheque h " +
                "        WHERE h.id_cheque = c.id_cheque " +
                "        AND h.fecha_cambio <= LAST_DAY(CONCAT(?, '-01')) " +
                "        ORDER BY h.fecha_cambio DESC, h.id_historial DESC " +
                "        LIMIT 1 " +
                "    ), " +
                "    2 " +
                ") <> 4";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);
            ps.setString(2, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    BigDecimal total =
                            rs.getBigDecimal("total");

                    return total != null
                            ? total
                            : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al obtener los cheques girados:"
            );

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================================================
    // CHEQUES EN CIRCULACIÓN AL CIERRE
    // =========================================================

    public BigDecimal obtenerTotalChequesCirculacion(String periodo) {

        // 1. Verificar si la conciliación ya fue guardada previamente
        String sqlGuardado = 
                "SELECT cheques_pendientes " +
                "FROM conciliaciones " +
                "WHERE periodo = ?";

        try (
                Connection conexion = Conexion.conectar();
                PreparedStatement psGuardado = conexion.prepareStatement(sqlGuardado)
        ) {

            psGuardado.setString(1, periodo);

            try (ResultSet rsGuardado = psGuardado.executeQuery()) {
                if (rsGuardado.next()) {
                    // Si ya existe guardada en la BD, retornar el valor congelado
                    BigDecimal congelado = rsGuardado.getBigDecimal("cheques_pendientes");
                    return congelado != null ? congelado : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al consultar conciliación guardada:");
            e.printStackTrace();
        }

        // 2. Si NO existe guardada (es un borrador/nuevo), calcular dinámicamente
        String sqlDinamico =
            "SELECT COALESCE(SUM(c.monto), 0) AS total " +
            "FROM cheques c " +
            "WHERE c.fecha_cheque <= LAST_DAY(STR_TO_DATE(CONCAT(?, '-01'), '%Y-%m-%d')) " +
            "AND COALESCE( " +
            "    ( " +
            "        SELECT h.estado_nuevo " +
            "        FROM historial_cheque h " +
            "        WHERE h.id_cheque = c.id_cheque " +
            "        AND h.fecha_cambio <= LAST_DAY(STR_TO_DATE(CONCAT(?, '-01'), '%Y-%m-%d')) " +
            "        ORDER BY h.fecha_cambio DESC, h.id_historial DESC " +
            "        LIMIT 1 " +
            "    ), " +
            "    c.estado " +
            ") = 2";

        try (
                Connection conn = Conexion.conectar();
                PreparedStatement psDinamico = conn.prepareStatement(sqlDinamico)
        ) {

            psDinamico.setString(1, periodo);
            psDinamico.setString(2, periodo);

            try (ResultSet rs = psDinamico.executeQuery()) {

                if (rs.next()) {
                    return rs.getBigDecimal("total");
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al calcular cheques en circulación dinámicamente:");
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================================================
    // CHEQUES PENDIENTES - MÉTODO ANTIGUO
    // =========================================================

    public BigDecimal obtenerTotalChequesPendientes(
            String periodo) {

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM cheques " +
                "WHERE estado = 2 " +
                "AND DATE_FORMAT(fecha_cheque, '%Y-%m') = ?";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    BigDecimal total =
                            rs.getBigDecimal("total");

                    return total != null
                            ? total
                            : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================================================
    // OBTENER SALDO SEGÚN LIBROS
    // =========================================================

    public BigDecimal obtenerSaldoLibros(
            String periodo) {

        String sql =
                "SELECT " +
                "COALESCE(( " +
                "    SELECT SUM(d.monto) " +
                "    FROM depositos d " +
                "    WHERE d.estado = 1 " +
                "    AND DATE_FORMAT(d.fecha, '%Y-%m') < ? " +
                "), 0) " +
                "-" +
                "COALESCE(( " +
                "    SELECT SUM(c.monto) " +
                "    FROM cheques c " +
                "    WHERE c.estado = 3 " +
                "    AND DATE_FORMAT(c.fecha_cheque, '%Y-%m') <= ? " +
                "), 0) " +
                "AS saldo_libros";

        try (
                Connection conexion =
                        Conexion.conectar();

                PreparedStatement ps =
                        conexion.prepareStatement(sql)
        ) {

            ps.setString(1, periodo);
            ps.setString(2, periodo);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    BigDecimal saldo =
                            rs.getBigDecimal("saldo_libros");

                    if (saldo != null) {
                        return saldo;
                    }
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================================================
    // CONVERTIR RESULTADO
    // =========================================================

    private Conciliacion convertirResultado(
            ResultSet rs)
            throws SQLException {

        Conciliacion conciliacion =
                new Conciliacion();

        conciliacion.setIdConciliacion(
                rs.getInt("id_conciliacion")
        );

        conciliacion.setPeriodo(
                rs.getString("periodo")
        );

        conciliacion.setSaldoLibros(
                rs.getBigDecimal("saldo_libros")
        );

        conciliacion.setDepositosTransito(
                rs.getBigDecimal("depositos_transito")
        );

        conciliacion.setChequesPendientes(
                rs.getBigDecimal("cheques_pendientes")
        );

        conciliacion.setSaldoBanco(
                rs.getBigDecimal("saldo_banco")
        );

        conciliacion.setDiferencia(
                rs.getBigDecimal("diferencia")
        );

        conciliacion.setFechaConciliacion(
                rs.getTimestamp("fecha_conciliacion")
        );

        conciliacion.setEstado(
                rs.getInt("estado")
        );

        conciliacion.setIdUsuario(
                rs.getInt("id_usuario")
        );

        conciliacion.setObservaciones(
                rs.getString("observaciones")
        );

        return conciliacion;
    }
}
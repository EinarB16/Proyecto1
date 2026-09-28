package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import config.Conexion;
import model.Cheque;

public class ChequeDAO {

    // =========================================================
    // OBTENER SIGUIENTE ID DEL CHEQUE
    // =========================================================
    private int obtenerSiguienteId(Connection conexion) throws SQLException {
        String sql = "SELECT COALESCE(MAX(id_cheque), 0) + 1 AS siguiente_id FROM cheques";

        try (PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("siguiente_id");
            }
        }

        return -1;
    }

    // =========================================================
    // OBTENER SIGUIENTE ID DEL HISTORIAL
    // =========================================================
    private int obtenerSiguienteIdHistorial(Connection conexion) throws SQLException {
        String sql = "SELECT COALESCE(MAX(id_historial), 0) + 1 AS siguiente_id FROM historial_cheque";

        try (PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("siguiente_id");
            }
        }

        return -1;
    }

    // =========================================================
    // REGISTRAR CHEQUE
    // =========================================================
    public boolean insertar(Cheque cheque) {
        String sql = "INSERT INTO cheques "
                   + "(id_cheque, numero_cheque, fecha_cheque, id_proveedor, "
                   + "monto, monto_letras, detalle, id_objeto_gasto, estado, "
                   + "id_usuario_creacion) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conexion = Conexion.conectar()) {

            int idCheque = obtenerSiguienteId(conexion);

            if (idCheque == -1) {
                return false;
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {
                ps.setInt(1, idCheque);
                ps.setString(2, cheque.getNumeroCheque());
                ps.setDate(3, cheque.getFechaCheque());
                ps.setInt(4, cheque.getIdProveedor());
                ps.setDouble(5, cheque.getMonto());
                ps.setString(6, cheque.getMontoLetras());
                ps.setString(7, cheque.getDetalle());
                ps.setInt(8, cheque.getIdObjetoGasto());
                ps.setInt(9, 1); // Estado inicial: 1 = Emitido
                ps.setInt(10, cheque.getIdUsuarioCreacion());

                ps.executeUpdate();
                cheque.setIdCheque(idCheque);

                return true;
            }

        } catch (SQLException e) {
            System.out.println("Error al registrar el cheque:");
            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // LISTAR TODOS LOS CHEQUES
    // =========================================================
    public List<Cheque> listarTodos() {
        List<Cheque> lista = new ArrayList<>();

        String sql = "SELECT c.*, "
                   + "p.nombre AS nombre_proveedor, "
                   + "o.descripcion AS descripcion_objeto_gasto "
                   + "FROM cheques c "
                   + "INNER JOIN proveedores p ON c.id_proveedor = p.id_proveedor "
                   + "INNER JOIN objeto_gasto o ON c.id_objeto_gasto = o.id_objeto_gasto "
                   + "ORDER BY c.fecha_cheque DESC, c.id_cheque DESC";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(convertirResultado(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error al listar los cheques:");
            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // BUSCAR CHEQUE POR ID
    // =========================================================
    public Cheque buscarPorId(int idCheque) {
        String sql = "SELECT c.*, "
                   + "p.nombre AS nombre_proveedor, "
                   + "o.descripcion AS descripcion_objeto_gasto "
                   + "FROM cheques c "
                   + "INNER JOIN proveedores p ON c.id_proveedor = p.id_proveedor "
                   + "INNER JOIN objeto_gasto o ON c.id_objeto_gasto = o.id_objeto_gasto "
                   + "WHERE c.id_cheque = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idCheque);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return convertirResultado(rs);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al buscar el cheque:");
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // CAMBIAR ESTADO DEL CHEQUE
    // =========================================================
    public boolean cambiarEstado(int idCheque, int nuevoEstado, int idUsuario, String observacion) {
        Connection conexion = null;

        try {
            conexion = Conexion.conectar();
            conexion.setAutoCommit(false);

            String sqlBuscar = "SELECT estado FROM cheques WHERE id_cheque = ?";
            int estadoAnterior;

            try (PreparedStatement ps = conexion.prepareStatement(sqlBuscar)) {
                ps.setInt(1, idCheque);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conexion.rollback();
                        return false;
                    }
                    estadoAnterior = rs.getInt("estado");
                }
            }

            if (nuevoEstado < 1 || nuevoEstado > 5 || estadoAnterior == nuevoEstado) {
                conexion.rollback();
                return false;
            }

            boolean cambioPermitido = false;

            if (estadoAnterior == 1 && (nuevoEstado == 2 || nuevoEstado == 4)) {
                cambioPermitido = true;
            } else if (estadoAnterior == 2 && (nuevoEstado == 3 || nuevoEstado == 4 || nuevoEstado == 5)) {
                cambioPermitido = true;
            }

            if (!cambioPermitido) {
                conexion.rollback();
                return false;
            }

            String sqlActualizar;
            if (nuevoEstado == 5) {
                sqlActualizar = "UPDATE cheques SET "
                              + "estado = ?, "
                              + "fecha_salida_circulacion = NOW(), "
                              + "observacion_salida = ? "
                              + "WHERE id_cheque = ?";
            } else {
                sqlActualizar = "UPDATE cheques SET "
                              + "estado = ? "
                              + "WHERE id_cheque = ?";
            }

            try (PreparedStatement ps = conexion.prepareStatement(sqlActualizar)) {
                if (nuevoEstado == 5) {
                    ps.setInt(1, nuevoEstado);
                    ps.setString(2, observacion);
                    ps.setInt(3, idCheque);
                } else {
                    ps.setInt(1, nuevoEstado);
                    ps.setInt(2, idCheque);
                }
                ps.executeUpdate();
            }

            int idHistorial = obtenerSiguienteIdHistorial(conexion);
            if (idHistorial == -1) {
                conexion.rollback();
                return false;
            }

            String sqlHistorial = "INSERT INTO historial_cheque "
                                + "(id_historial, id_cheque, estado_anterior, "
                                + "estado_nuevo, id_usuario, observacion) "
                                + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conexion.prepareStatement(sqlHistorial)) {
                ps.setInt(1, idHistorial);
                ps.setInt(2, idCheque);
                ps.setInt(3, estadoAnterior);
                ps.setInt(4, nuevoEstado);
                ps.setInt(5, idUsuario);
                ps.setString(6, observacion);
                ps.executeUpdate();
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
            System.out.println("Error al cambiar el estado del cheque:");
            e.printStackTrace();

        } finally {
            if (conexion != null) {
                try {
                    conexion.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // =========================================================
    // ANULAR CHEQUE
    // =========================================================
    public boolean anular(int idCheque, int idUsuario, String motivo) {
        Connection conexion = null;

        try {
            conexion = Conexion.conectar();
            conexion.setAutoCommit(false);

            String sqlBuscar = "SELECT estado FROM cheques WHERE id_cheque = ?";
            int estadoAnterior;

            try (PreparedStatement ps = conexion.prepareStatement(sqlBuscar)) {
                ps.setInt(1, idCheque);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conexion.rollback();
                        return false;
                    }
                    estadoAnterior = rs.getInt("estado");
                }
            }

            if (estadoAnterior == 4) {
                conexion.rollback();
                return false;
            }

            String sqlActualizar = "UPDATE cheques SET "
                                 + "estado = 4, "
                                 + "fecha_anulacion = NOW(), "
                                 + "motivo_anulacion = ?, "
                                 + "id_usuario_anulacion = ? "
                                 + "WHERE id_cheque = ?";

            try (PreparedStatement ps = conexion.prepareStatement(sqlActualizar)) {
                ps.setString(1, motivo);
                ps.setInt(2, idUsuario);
                ps.setInt(3, idCheque);
                ps.executeUpdate();
            }

            int idHistorial = obtenerSiguienteIdHistorial(conexion);
            if (idHistorial == -1) {
                conexion.rollback();
                return false;
            }

            String sqlHistorial = "INSERT INTO historial_cheque "
                                + "(id_historial, id_cheque, estado_anterior, "
                                + "estado_nuevo, id_usuario, observacion) "
                                + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conexion.prepareStatement(sqlHistorial)) {
                ps.setInt(1, idHistorial);
                ps.setInt(2, idCheque);
                ps.setInt(3, estadoAnterior);
                ps.setInt(4, 4);
                ps.setInt(5, idUsuario);
                ps.setString(6, motivo);
                ps.executeUpdate();
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
            System.out.println("Error al anular el cheque:");
            e.printStackTrace();

        } finally {
            if (conexion != null) {
                try {
                    conexion.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // =========================================================
    // BUSCAR CHEQUES CON FILTROS
    // =========================================================
    public List<Cheque> buscarConFiltros(String fechaInicio,
                                         String fechaFin,
                                         String numeroCheque,
                                         String idProveedor,
                                         String estado) {

        List<Cheque> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT c.*, " +
                "p.nombre AS nombre_proveedor, " +
                "o.descripcion AS descripcion_objeto_gasto " +
                "FROM cheques c " +
                "INNER JOIN proveedores p ON c.id_proveedor = p.id_proveedor " +
                "INNER JOIN objeto_gasto o ON c.id_objeto_gasto = o.id_objeto_gasto " +
                "WHERE 1=1 "
        );

        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            sql.append("AND c.fecha_cheque >= ? ");
        }

        if (fechaFin != null && !fechaFin.isEmpty()) {
            sql.append("AND c.fecha_cheque <= ? ");
        }

        if (numeroCheque != null && !numeroCheque.trim().isEmpty()) {
            sql.append("AND c.numero_cheque = ? ");
        }

        if (idProveedor != null && !idProveedor.isEmpty()) {
            sql.append("AND c.id_proveedor = ? ");
        }

        if (estado != null && !estado.isEmpty()) {
            sql.append("AND c.estado = ? ");
        }

        sql.append("ORDER BY c.fecha_cheque DESC, c.id_cheque DESC");

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql.toString())) {

            int posicion = 1;

            if (fechaInicio != null && !fechaInicio.isEmpty()) {
                ps.setDate(posicion++, java.sql.Date.valueOf(fechaInicio));
            }

            if (fechaFin != null && !fechaFin.isEmpty()) {
                ps.setDate(posicion++, java.sql.Date.valueOf(fechaFin));
            }

            if (numeroCheque != null && !numeroCheque.trim().isEmpty()) {
                ps.setString(posicion++, numeroCheque.trim());
            }

            if (idProveedor != null && !idProveedor.isEmpty()) {
                ps.setInt(posicion++, Integer.parseInt(idProveedor));
            }

            if (estado != null && !estado.isEmpty()) {
                ps.setInt(posicion++, Integer.parseInt(estado));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(convertirResultado(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Error al buscar cheques con filtros:");
            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // CONVERTIR RESULTADO SQL A OBJETO CHEQUE
    // =========================================================
    private Cheque convertirResultado(ResultSet rs) throws SQLException {
        Cheque cheque = new Cheque();

        cheque.setIdCheque(rs.getInt("id_cheque"));
        cheque.setNumeroCheque(rs.getString("numero_cheque"));
        cheque.setFechaCheque(rs.getDate("fecha_cheque"));
        cheque.setIdProveedor(rs.getInt("id_proveedor"));
        cheque.setMonto(rs.getDouble("monto"));
        cheque.setMontoLetras(rs.getString("monto_letras"));
        cheque.setDetalle(rs.getString("detalle"));
        cheque.setIdObjetoGasto(rs.getInt("id_objeto_gasto"));
        cheque.setEstado(rs.getInt("estado"));
        cheque.setFechaAnulacion(rs.getTimestamp("fecha_anulacion"));
        cheque.setMotivoAnulacion(rs.getString("motivo_anulacion"));
        cheque.setFechaSalidaCirculacion(rs.getTimestamp("fecha_salida_circulacion"));
        cheque.setObservacionSalida(rs.getString("observacion_salida"));
        cheque.setIdUsuarioCreacion(rs.getInt("id_usuario_creacion"));

        int idUsuarioAnulacion = rs.getInt("id_usuario_anulacion");
        if (rs.wasNull()) {
            cheque.setIdUsuarioAnulacion(null);
        } else {
            cheque.setIdUsuarioAnulacion(idUsuarioAnulacion);
        }

        cheque.setNombreProveedor(rs.getString("nombre_proveedor"));
        cheque.setDescripcionObjetoGasto(rs.getString("descripcion_objeto_gasto"));

        return cheque;
    }

    // =========================================================
    // OBTENER SIGUIENTE NÚMERO DE CHEQUE
    // =========================================================
    public String obtenerSiguienteNumeroCheque() {
        String sql = "SELECT COALESCE(MAX(CAST(numero_cheque AS UNSIGNED)), 0) + 1 AS siguiente_numero FROM cheques";

        try (Connection con = Conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return String.valueOf(rs.getLong("siguiente_numero"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "1";
    }
}
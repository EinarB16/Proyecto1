package dao;

import config.Conexion;
import model.Deposito;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DepositoDAO {

    // =========================================================
    // REGISTRAR UN DEPÓSITO
    // =========================================================

    public boolean insertar(Deposito deposito) {

        String sqlId =
            "SELECT COALESCE(MAX(id_deposito), 0) + 1 " +
            "AS siguiente_id FROM depositos";

        String sqlComprobante =
            "SELECT COALESCE(" +
            "MAX(CAST(numero_comprobante AS UNSIGNED)), 0" +
            ") + 1 AS siguiente_comprobante " +
            "FROM depositos";

        String sql =
            "INSERT INTO depositos " +
            "(id_deposito, numero_comprobante, tipo_deposito, " +
            "fecha, monto, detalle, estado, id_usuario) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement psId =
                 conexion.prepareStatement(sqlId);
             ResultSet rsId =
                 psId.executeQuery();
             PreparedStatement psComprobante =
                 conexion.prepareStatement(sqlComprobante);
             ResultSet rsComprobante =
                 psComprobante.executeQuery()) {

            int siguienteId = 1;

            if (rsId.next()) {
                siguienteId =
                    rsId.getInt("siguiente_id");
            }

            int siguienteComprobante = 1;

            if (rsComprobante.next()) {
                siguienteComprobante =
                    rsComprobante.getInt(
                        "siguiente_comprobante"
                    );
            }

            try (PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

                ps.setInt(1, siguienteId);

                ps.setString(
                    2,
                    String.valueOf(siguienteComprobante)
                );

                ps.setInt(
                    3,
                    deposito.getTipoDeposito()
                );

                ps.setDate(
                    4,
                    deposito.getFecha()
                );

                ps.setDouble(
                    5,
                    deposito.getMonto()
                );

                ps.setString(
                    6,
                    deposito.getDetalle()
                );

                ps.setInt(
                    7,
                    deposito.getEstado()
                );

                ps.setInt(
                    8,
                    deposito.getIdUsuario()
                );

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {

            System.out.println(
                "Error al registrar depósito:"
            );

            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // OBTENER SIGUIENTE COMPROBANTE
    // =========================================================

    public String obtenerSiguienteComprobante() {

        String sql =
            "SELECT COALESCE(" +
            "MAX(CAST(numero_comprobante AS UNSIGNED)), 0" +
            ") + 1 AS siguiente_comprobante " +
            "FROM depositos";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return String.valueOf(
                    rs.getInt("siguiente_comprobante")
                );
            }

        } catch (Exception e) {

            System.out.println(
                "Error al obtener el siguiente " +
                "número de comprobante:"
            );

            e.printStackTrace();
        }

        return "";
    }

    // =========================================================
    // LISTAR TODOS LOS DEPÓSITOS
    // =========================================================

    public List<Deposito> listarTodos() {

        List<Deposito> lista =
            new ArrayList<>();

        String sql =
            "SELECT * FROM depositos " +
            "ORDER BY fecha DESC, id_deposito DESC";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                lista.add(
                    convertirResultado(rs)
                );
            }

        } catch (Exception e) {

            System.out.println(
                "Error al listar depósitos:"
            );

            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // BUSCAR DEPÓSITO POR ID
    // =========================================================

    public Deposito buscarPorId(int idDeposito) {

        String sql =
            "SELECT * FROM depositos " +
            "WHERE id_deposito = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(1, idDeposito);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {

                    return convertirResultado(rs);
                }
            }

        } catch (Exception e) {

            System.out.println(
                "Error al buscar depósito:"
            );

            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // BUSCAR DEPÓSITOS CON FILTROS
    // =========================================================

    public List<Deposito> buscarConFiltros(
            String fechaInicio,
            String fechaFin,
            String numeroComprobante,
            String tipoDeposito) {

        List<Deposito> lista =
            new ArrayList<>();

        StringBuilder sql =
            new StringBuilder(
                "SELECT * FROM depositos WHERE 1=1 "
            );

        if (fechaInicio != null &&
            !fechaInicio.isEmpty()) {

            sql.append("AND fecha >= ? ");
        }

        if (fechaFin != null &&
            !fechaFin.isEmpty()) {

            sql.append("AND fecha <= ? ");
        }

        if (numeroComprobante != null &&
            !numeroComprobante.trim().isEmpty()) {

            sql.append(
                "AND numero_comprobante = ? "
            );
        }

        if (tipoDeposito != null &&
            !tipoDeposito.isEmpty()) {

            sql.append(
                "AND tipo_deposito = ? "
            );
        }

        sql.append(
            "ORDER BY fecha DESC, id_deposito DESC"
        );

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(
                     sql.toString()
                 )) {

            int posicion = 1;

            if (fechaInicio != null &&
                !fechaInicio.isEmpty()) {

                ps.setDate(
                    posicion++,
                    java.sql.Date.valueOf(
                        fechaInicio
                    )
                );
            }

            if (fechaFin != null &&
                !fechaFin.isEmpty()) {

                ps.setDate(
                    posicion++,
                    java.sql.Date.valueOf(
                        fechaFin
                    )
                );
            }

            if (numeroComprobante != null &&
                !numeroComprobante.trim().isEmpty()) {

                ps.setString(
                    posicion++,
                    numeroComprobante.trim()
                );
            }

            if (tipoDeposito != null &&
                !tipoDeposito.isEmpty()) {

                ps.setInt(
                    posicion++,
                    Integer.parseInt(tipoDeposito)
                );
            }

            try (ResultSet rs =
                     ps.executeQuery()) {

                while (rs.next()) {

                    lista.add(
                        convertirResultado(rs)
                    );
                }
            }

        } catch (Exception e) {

            System.out.println(
                "Error al buscar depósitos con filtros:"
            );

            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // ACTUALIZAR UN DEPÓSITO
    // =========================================================

    public boolean actualizar(Deposito deposito) {

        String sql =
            "UPDATE depositos SET " +
            "numero_comprobante = ?, " +
            "tipo_deposito = ?, " +
            "fecha = ?, " +
            "monto = ?, " +
            "detalle = ? " +
            "WHERE id_deposito = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setString(
                1,
                deposito.getNumeroComprobante()
            );

            ps.setInt(
                2,
                deposito.getTipoDeposito()
            );

            ps.setDate(
                3,
                deposito.getFecha()
            );

            ps.setDouble(
                4,
                deposito.getMonto()
            );

            ps.setString(
                5,
                deposito.getDetalle()
            );

            ps.setInt(
                6,
                deposito.getIdDeposito()
            );

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println(
                "Error al actualizar depósito:"
            );

            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // CAMBIAR ESTADO
    // =========================================================

    public boolean cambiarEstado(
            int idDeposito,
            int nuevoEstado) {

        String sql =
            "UPDATE depositos SET estado = ? " +
            "WHERE id_deposito = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idDeposito);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println(
                "Error al cambiar estado del depósito:"
            );

            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // CONVERTIR RESULTADO SQL A OBJETO DEPOSITO
    // =========================================================

    private Deposito convertirResultado(
            ResultSet rs) throws Exception {

        Deposito deposito =
            new Deposito();

        deposito.setIdDeposito(
            rs.getInt("id_deposito")
        );

        deposito.setNumeroComprobante(
            rs.getString("numero_comprobante")
        );

        deposito.setTipoDeposito(
            rs.getInt("tipo_deposito")
        );

        deposito.setFecha(
            rs.getDate("fecha")
        );

        deposito.setMonto(
            rs.getDouble("monto")
        );

        deposito.setDetalle(
            rs.getString("detalle")
        );

        deposito.setEstado(
            rs.getInt("estado")
        );

        deposito.setIdUsuario(
            rs.getInt("id_usuario")
        );

        deposito.setFechaRegistro(
            rs.getTimestamp("fecha_registro")
        );

        return deposito;
    }
}
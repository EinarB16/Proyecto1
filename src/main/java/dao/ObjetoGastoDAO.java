package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import config.Conexion;
import model.ObjetoGasto;

public class ObjetoGastoDAO {

    // =========================================================
    // LISTAR OBJETOS DE GASTO DISPONIBLES
    // =========================================================

    // Obtiene los objetos de gasto que se pueden utilizar.
    public List<ObjetoGasto> listarDisponibles() {

        List<ObjetoGasto> lista = new ArrayList<>();

        String sql = "SELECT * FROM objeto_gasto "
                   + "WHERE estado IN (1, 2, 3, 6) "
                   + "ORDER BY codigo ASC";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ObjetoGasto objeto = new ObjetoGasto();

                objeto.setIdObjetoGasto(
                        rs.getInt("id_objeto_gasto")
                );

                objeto.setCodigo(
                        rs.getString("codigo")
                );

                objeto.setDescripcion(
                        rs.getString("descripcion")
                );

                objeto.setEstado(
                        rs.getInt("estado")
                );

                objeto.setFechaCreacion(
                        rs.getTimestamp("fecha_creacion")
                );

                lista.add(objeto);
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al listar los objetos de gasto:"
            );

            e.printStackTrace();
        }

        return lista;
    }


    // =========================================================
    // BUSCAR OBJETO DE GASTO POR ID
    // =========================================================

    // Busca un objeto de gasto específico utilizando su ID.
    public ObjetoGasto buscarPorId(int idObjetoGasto) {

        String sql = "SELECT * FROM objeto_gasto "
                   + "WHERE id_objeto_gasto = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idObjetoGasto);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    ObjetoGasto objeto = new ObjetoGasto();

                    objeto.setIdObjetoGasto(
                            rs.getInt("id_objeto_gasto")
                    );

                    objeto.setCodigo(
                            rs.getString("codigo")
                    );

                    objeto.setDescripcion(
                            rs.getString("descripcion")
                    );

                    objeto.setEstado(
                            rs.getInt("estado")
                    );

                    objeto.setFechaCreacion(
                            rs.getTimestamp("fecha_creacion")
                    );

                    return objeto;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al buscar el objeto de gasto:"
            );

            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // REGISTRAR OBJETO DE GASTO
    // =========================================================

    // Verifica si ya existe un objeto de gasto con el mismo código.
    public boolean existeCodigo(String codigo) {

        String sql = "SELECT COUNT(*) FROM objeto_gasto WHERE codigo = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al verificar el código del objeto de gasto:");
            e.printStackTrace();
        }

        return false;
    }

    // Registra un nuevo objeto de gasto y genera su ID manualmente.
    public boolean insertar(ObjetoGasto objeto) {

        String sqlId = "SELECT COALESCE(MAX(id_objeto_gasto), 0) + 1 FROM objeto_gasto";

        String sql = "INSERT INTO objeto_gasto "
                   + "(id_objeto_gasto, codigo, descripcion, estado, fecha_creacion) "
                   + "VALUES (?, ?, ?, ?, NOW())";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement psId = conexion.prepareStatement(sqlId)) {

            int siguienteId = 1;

            try (ResultSet rs = psId.executeQuery()) {
                if (rs.next()) {
                    siguienteId = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                ps.setInt(1, siguienteId);
                ps.setString(2, objeto.getCodigo());
                ps.setString(3, objeto.getDescripcion());
                ps.setInt(4, objeto.getEstado());

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error al registrar el objeto de gasto:");
            e.printStackTrace();
        }

        return false;
    }

}
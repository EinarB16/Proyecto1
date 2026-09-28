package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import config.Conexion;

public class BitacoraDAO {

    // Obtiene el siguiente ID disponible para la tabla bitacora.
    // La base de datos no tiene AUTO_INCREMENT en id_bitacora.
    private int obtenerSiguienteId() {

        String sql = "SELECT COALESCE(MAX(id_bitacora), 0) + 1 AS siguiente_id "
                   + "FROM bitacora";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("siguiente_id");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener el siguiente ID de bitacora:");
            e.printStackTrace();
        }

        return -1;
    }


    // Registra una acción realizada por un usuario.
    public void registrarAccion(int idUsuario, String accion,
                                String tablaAfectada, String descripcion) {

        int idBitacora = obtenerSiguienteId();

        if (idBitacora == -1) {
            return;
        }

        String sql = "INSERT INTO bitacora "
                   + "(id_bitacora, id_usuario, accion, tabla_afectada, descripcion) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idBitacora);
            ps.setInt(2, idUsuario);
            ps.setString(3, accion);
            ps.setString(4, tablaAfectada);
            ps.setString(5, descripcion);

            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error al registrar la acción en bitacora:");
            e.printStackTrace();
        }
    }
}
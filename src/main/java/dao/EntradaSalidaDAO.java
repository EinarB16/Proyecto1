package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import config.Conexion;

public class EntradaSalidaDAO {

    // Obtiene el siguiente ID disponible para la tabla entradas_y_salidas.
    // La base de datos no tiene AUTO_INCREMENT en id_log,
    // por eso debemos generar el ID desde la aplicación.
    private int obtenerSiguienteId() {

        String sql = "SELECT COALESCE(MAX(id_log), 0) + 1 AS siguiente_id "
                   + "FROM entradas_y_salidas";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("siguiente_id");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener el siguiente ID:");
            e.printStackTrace();
        }

        return -1;
    }


    // Registra la entrada del usuario al sistema.
    // Devuelve el id_log creado para poder utilizarlo posteriormente
    // cuando el usuario cierre sesión.
    public int registrarEntrada(int idUsuario) {

        int idLog = obtenerSiguienteId();

        if (idLog == -1) {
            return -1;
        }

        String sql = "INSERT INTO entradas_y_salidas "
                   + "(id_log, id_usuario, fecha_entrada, intentos_fallidos) "
                   + "VALUES (?, ?, NOW(), 0)";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idLog);
            ps.setInt(2, idUsuario);

            ps.executeUpdate();

            return idLog;

        } catch (SQLException e) {
            System.out.println("Error al registrar la entrada:");
            e.printStackTrace();
        }

        return -1;
    }


    // Registra la fecha y hora de salida del usuario.
    public void registrarSalida(int idLog) {

        String sql = "UPDATE entradas_y_salidas "
                   + "SET fecha_salida = NOW() "
                   + "WHERE id_log = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idLog);

            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error al registrar la salida:");
            e.printStackTrace();
        }
    }
}
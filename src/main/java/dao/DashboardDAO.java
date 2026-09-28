package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import config.Conexion;

public class DashboardDAO {

    // =========================================================
    // TOTAL DE CHEQUES EMITIDOS
    // =========================================================

    public int obtenerTotalChequesEmitidos() {

        String sql = "SELECT COUNT(*) AS total FROM cheques";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener total de cheques emitidos:");
            e.printStackTrace();
        }

        return 0;
    }


    // =========================================================
    // TOTAL DE CHEQUES PENDIENTES
    // =========================================================

    public int obtenerTotalChequesPendientes() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM cheques " +
                "WHERE estado = 2";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener total de cheques pendientes:");
            e.printStackTrace();
        }

        return 0;
    }


    // =========================================================
    // TOTAL DE CHEQUES ANULADOS
    // =========================================================

    public int obtenerTotalChequesAnulados() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM cheques " +
                "WHERE estado = 4";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener total de cheques anulados:");
            e.printStackTrace();
        }

        return 0;
    }


    // =========================================================
    // TOTAL DE DEPÓSITOS
    // =========================================================

    public int obtenerTotalDepositos() {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM depositos";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener total de depósitos:");
            e.printStackTrace();
        }

        return 0;
    }


    // =========================================================
    // MONTO TOTAL DE CHEQUES
    // =========================================================

    public BigDecimal obtenerMontoTotalCheques() {

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM cheques";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener monto total de cheques:");
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }


    // =========================================================
    // MONTO TOTAL DE DEPÓSITOS
    // =========================================================

    public BigDecimal obtenerMontoTotalDepositos() {

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM depositos";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener monto total de depósitos:");
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }


    // =========================================================
    // ÚLTIMA CONCILIACIÓN REALIZADA
    // =========================================================

    public String obtenerUltimaConciliacion() {

        String sql =
                "SELECT periodo " +
                "FROM conciliaciones " +
                "ORDER BY fecha_conciliacion DESC " +
                "LIMIT 1";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getString("periodo");
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener última conciliación:");
            e.printStackTrace();
        }

        return "No hay conciliaciones";
    }
}
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import config.Conexion;
import model.Proveedor;

public class ProveedorDAO {

    // =========================================================
    // MÉTODOS AUXILIARES DE "LIMPIEZA"
    // =========================================================

    // Elimina caracteres especiales peligrosos y mantiene solo texto/números seguros
    private String sanearTexto(String input) {
        if (input == null) return null;
        return input.replaceAll("[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ .,&'\\-@]", "").trim();
    }

    // Permite únicamente números y guiones (remueve letras como 'e'/'E' y símbolos)
    private String sanearRuc(String input) {
        if (input == null) return null;
        return input.replaceAll("[^0-9\\-]", "").trim();
    }

    // =========================================================
    // BUSCAR PROVEEDORES CON FILTROS
    // =========================================================
    public List<Proveedor> buscarConFiltros(String nombre, String ruc, String estado) {

        List<Proveedor> lista = new ArrayList<>();

        // Saneamos los filtros de entrada antes de armar la consulta
        String nombreLimpio = sanearTexto(nombre);
        String rucLimpio = sanearRuc(ruc);

        // Consulta base
        StringBuilder sql = new StringBuilder("SELECT * FROM proveedores WHERE 1=1 ");
        List<Object> parametros = new ArrayList<>();

        // Filtro por nombre
        if (nombreLimpio != null && !nombreLimpio.isEmpty()) {
            sql.append("AND nombre LIKE ? ");
            parametros.add("%" + nombreLimpio + "%");
        }

        // Filtro por RUC
        if (rucLimpio != null && !rucLimpio.isEmpty()) {
            sql.append("AND ruc LIKE ? ");
            parametros.add("%" + rucLimpio + "%");
        }

        // Filtro por estado
        if (estado != null && !estado.trim().isEmpty()) {
            try {
                int estadoVal = Integer.parseInt(estado.trim());
                if (estadoVal == 0 || estadoVal == 1) {
                    sql.append("AND estado = ? ");
                    parametros.add(estadoVal);
                }
            } catch (NumberFormatException ignored) {
                // Si mandan un estado corrupto, simplemente se ignora el filtro
            }
        }

        // Ordenamos los resultados por nombre
        sql.append("ORDER BY nombre ASC");

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql.toString())) {

            // Asignamos parámetros dinámicos en la consulta preparada
            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Proveedor proveedor = new Proveedor();
                    proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                    proveedor.setNombre(rs.getString("nombre"));
                    proveedor.setTelefono(rs.getString("telefono"));
                    proveedor.setCorreo(rs.getString("correo"));
                    proveedor.setEstado(rs.getInt("estado"));
                    proveedor.setRuc(rs.getString("ruc"));

                    lista.add(proveedor);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al buscar proveedores con filtros:");
            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // INSERTAR PROVEEDOR
    // =========================================================
    public boolean insertar(Proveedor proveedor) {

        if (proveedor == null) return false;

        // Limpiamos los datos del objeto antes de guardarlos en BD
        String nombreLimpio = sanearTexto(proveedor.getNombre());
        String rucLimpio = sanearRuc(proveedor.getRuc());
        String telefonoLimpio = sanearRuc(proveedor.getTelefono());
        String correoLimpio = sanearTexto(proveedor.getCorreo());

        String sqlId = "SELECT COALESCE(MAX(id_proveedor), 0) + 1 FROM proveedores";
        String sql = "INSERT INTO proveedores (id_proveedor, nombre, telefono, correo, estado, ruc) VALUES (?, ?, ?, ?, ?, ?)";

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
                ps.setString(2, nombreLimpio);
                ps.setString(3, (telefonoLimpio != null && !telefonoLimpio.isEmpty()) ? telefonoLimpio : null);
                ps.setString(4, (correoLimpio != null && !correoLimpio.isEmpty()) ? correoLimpio : null);
                ps.setInt(5, proveedor.getEstado());
                ps.setString(6, rucLimpio);

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // LISTAR PROVEEDORES ACTIVOS
    // =========================================================
    public List<Proveedor> listarActivos() {

        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM proveedores WHERE estado = 1 ORDER BY nombre ASC";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Proveedor proveedor = new Proveedor();
                proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                proveedor.setNombre(rs.getString("nombre"));
                proveedor.setTelefono(rs.getString("telefono"));
                proveedor.setCorreo(rs.getString("correo"));
                proveedor.setEstado(rs.getInt("estado"));
                proveedor.setRuc(rs.getString("ruc"));

                lista.add(proveedor);
            }

        } catch (SQLException e) {
            System.out.println("Error al listar los proveedores activos:");
            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // BUSCAR PROVEEDOR POR ID
    // =========================================================
    public Proveedor buscarPorId(int idProveedor) {

        String sql = "SELECT * FROM proveedores WHERE id_proveedor = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idProveedor);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Proveedor proveedor = new Proveedor();
                    proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                    proveedor.setNombre(rs.getString("nombre"));
                    proveedor.setTelefono(rs.getString("telefono"));
                    proveedor.setCorreo(rs.getString("correo"));
                    proveedor.setEstado(rs.getInt("estado"));
                    proveedor.setRuc(rs.getString("ruc"));

                    return proveedor;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al buscar el proveedor por ID:");
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // CAMBIAR ESTADO DEL PROVEEDOR
    // =========================================================
    public boolean cambiarEstado(int idProveedor, int nuevoEstado) {

        String sql = "UPDATE proveedores SET estado = ? WHERE id_proveedor = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idProveedor);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al cambiar el estado del proveedor:");
            e.printStackTrace();
            return false;
        }
    }
    
 // =========================================================
 // ACTUALIZAR PROVEEDOR
 // =========================================================
 public boolean actualizar(Proveedor proveedor) {

     if (proveedor == null) {
         return false;
     }

     // Limpiamos los datos antes de actualizar.
     String nombreLimpio =
         sanearTexto(proveedor.getNombre());

     String rucLimpio =
         sanearRuc(proveedor.getRuc());

     String telefonoLimpio =
         sanearRuc(proveedor.getTelefono());

     String correoLimpio =
         sanearTexto(proveedor.getCorreo());

     String sql =
         "UPDATE proveedores SET "
         + "nombre = ?, "
         + "telefono = ?, "
         + "correo = ?, "
         + "ruc = ? "
         + "WHERE id_proveedor = ?";

     try (Connection conexion = Conexion.conectar();
          PreparedStatement ps =
              conexion.prepareStatement(sql)) {

         ps.setString(
             1,
             nombreLimpio
         );

         ps.setString(
             2,
             (telefonoLimpio != null &&
              !telefonoLimpio.isEmpty())
             ? telefonoLimpio
             : null
         );

         ps.setString(
             3,
             (correoLimpio != null &&
              !correoLimpio.isEmpty())
             ? correoLimpio
             : null
         );

         ps.setString(
             4,
             rucLimpio
         );

         ps.setInt(
             5,
             proveedor.getIdProveedor()
         );

         return ps.executeUpdate() > 0;

     } catch (SQLException e) {

         System.out.println(
             "Error al actualizar el proveedor:"
         );

         e.printStackTrace();

         return false;
     }
 }
 
 public boolean existeRuc(String ruc, int idProveedorExcluir) {

	    String sql =
	        "SELECT COUNT(*) " +
	        "FROM proveedores " +
	        "WHERE ruc = ? " +
	        "AND id_proveedor <> ?";

	    try (Connection conexion = Conexion.conectar();
	         PreparedStatement ps = conexion.prepareStatement(sql)) {

	        ps.setString(1, ruc);
	        ps.setInt(2, idProveedorExcluir);

	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt(1) > 0;
	            }
	        }

	    } catch (SQLException e) {
	        System.out.println("Error al verificar RUC:");
	        e.printStackTrace();
	    }

	    return false;
	}
 
 public boolean existeRuc(String ruc) {

	    String sql =
	        "SELECT COUNT(*) " +
	        "FROM proveedores " +
	        "WHERE ruc = ?";

	    try (Connection conexion = Conexion.conectar();
	         PreparedStatement ps = conexion.prepareStatement(sql)) {

	        ps.setString(1, ruc);

	        try (ResultSet rs = ps.executeQuery()) {

	            if (rs.next()) {
	                return rs.getInt(1) > 0;
	            }
	        }

	    } catch (SQLException e) {

	        System.out.println("Error al verificar RUC:");
	        e.printStackTrace();

	    }

	    return false;
	}
}
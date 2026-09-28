package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import config.Conexion;
import model.Usuario;

public class UsuarioDAO {

    // =========================================================
    // BUSCAR USUARIO POR NOMBRE DE USUARIO
    // =========================================================

    public Usuario buscarPorUsuario(String nombreUsuario) {

        String sql = "SELECT * FROM usuarios WHERE usuario = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Usuario usuario = new Usuario();

                    usuario.setIdUsuario(
                        rs.getInt("id_usuario")
                    );

                    usuario.setNombre(
                        rs.getString("nombre")
                    );

                    usuario.setApellido(
                        rs.getString("apellido")
                    );

                    usuario.setUsuario(
                        rs.getString("usuario")
                    );

                    usuario.setPassword(
                        rs.getString("password")
                    );

                    usuario.setCorreo(
                        rs.getString("correo")
                    );

                    usuario.setRol(
                        rs.getString("rol")
                    );

                    usuario.setEstado(
                        rs.getInt("estado")
                    );

                    usuario.setFechaCreacion(
                        rs.getTimestamp("fecha_creacion")
                    );

                    usuario.setIntentosFallidos(
                        rs.getInt("intentos_fallidos")
                    );

                    usuario.setBloqueadoHasta(
                        rs.getTimestamp("bloqueado_hasta")
                    );

                    return usuario;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al buscar usuario:"
            );

            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // BUSCAR USUARIO POR ID
    // =========================================================

    public Usuario buscarPorId(int idUsuario) {

        String sql =
            "SELECT * FROM usuarios " +
            "WHERE id_usuario = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Usuario usuario = new Usuario();

                    usuario.setIdUsuario(
                        rs.getInt("id_usuario")
                    );

                    usuario.setNombre(
                        rs.getString("nombre")
                    );

                    usuario.setApellido(
                        rs.getString("apellido")
                    );

                    usuario.setUsuario(
                        rs.getString("usuario")
                    );

                    usuario.setPassword(
                        rs.getString("password")
                    );

                    usuario.setCorreo(
                        rs.getString("correo")
                    );

                    usuario.setRol(
                        rs.getString("rol")
                    );

                    usuario.setEstado(
                        rs.getInt("estado")
                    );

                    usuario.setFechaCreacion(
                        rs.getTimestamp("fecha_creacion")
                    );

                    usuario.setIntentosFallidos(
                        rs.getInt("intentos_fallidos")
                    );

                    usuario.setBloqueadoHasta(
                        rs.getTimestamp("bloqueado_hasta")
                    );

                    return usuario;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al buscar usuario por ID:"
            );

            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // COMPROBAR EXISTENCIA DE USUARIO
    // =========================================================

    public boolean existeUsuario(String nombreUsuario) {

        String sql =
            "SELECT COUNT(*) " +
            "FROM usuarios " +
            "WHERE usuario = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al verificar existencia de usuario:"
            );

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // COMPROBAR EXISTENCIA DE USUARIO EXCLUYENDO UN ID
    // =========================================================

    public boolean existeUsuario(
            String nombreUsuario,
            int idUsuarioExcluir) {

        String sql =
            "SELECT COUNT(*) " +
            "FROM usuarios " +
            "WHERE usuario = ? " +
            "AND id_usuario <> ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario);
            ps.setInt(2, idUsuarioExcluir);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al verificar existencia de usuario:"
            );

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // AUMENTAR INTENTOS FALLIDOS
    // =========================================================

    public void aumentarIntentosFallidos(
            int idUsuario) {

        String sql =
            "UPDATE usuarios " +
            "SET intentos_fallidos = intentos_fallidos + 1 " +
            "WHERE id_usuario = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            ps.executeUpdate();

        } catch (SQLException e) {

            System.out.println(
                "Error al aumentar los intentos fallidos:"
            );

            e.printStackTrace();
        }
    }


    // =========================================================
    // REINICIAR INTENTOS
    // =========================================================

    public void reiniciarIntentos(
            int idUsuario) {

        String sql =
            "UPDATE usuarios " +
            "SET intentos_fallidos = 0, " +
            "bloqueado_hasta = NULL " +
            "WHERE id_usuario = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            ps.executeUpdate();

        } catch (SQLException e) {

            System.out.println(
                "Error al reiniciar los intentos:"
            );

            e.printStackTrace();
        }
    }


    // =========================================================
    // BLOQUEAR USUARIO
    // =========================================================

    public void bloquearUsuario(
            int idUsuario) {

        String sql =
            "UPDATE usuarios " +
            "SET bloqueado_hasta = " +
            "DATE_ADD(NOW(), INTERVAL 5 MINUTE) " +
            "WHERE id_usuario = ?";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            ps.executeUpdate();

        } catch (SQLException e) {

            System.out.println(
                "Error al bloquear el usuario:"
            );

            e.printStackTrace();
        }
    }


    // =========================================================
    // COMPROBAR SI ESTÁ BLOQUEADO
    // =========================================================

    public boolean estaBloqueado(
            Usuario usuario) {

        if (usuario.getBloqueadoHasta() == null) {

            return false;
        }

        return usuario.getBloqueadoHasta().after(
            new java.sql.Timestamp(
                System.currentTimeMillis()
            )
        );
    }


    // =========================================================
    // LISTAR TODOS LOS USUARIOS
    // =========================================================

    public List<Usuario> listarTodos() {

        List<Usuario> lista =
            new ArrayList<>();

        String sql =
            "SELECT * FROM usuarios " +
            "ORDER BY nombre, apellido";

        try (Connection conexion = Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql);
             ResultSet rs =
                 ps.executeQuery()) {

            while (rs.next()) {

                Usuario usuario =
                    new Usuario();

                usuario.setIdUsuario(
                    rs.getInt("id_usuario")
                );

                usuario.setNombre(
                    rs.getString("nombre")
                );

                usuario.setApellido(
                    rs.getString("apellido")
                );

                usuario.setUsuario(
                    rs.getString("usuario")
                );

                usuario.setPassword(
                    rs.getString("password")
                );

                usuario.setCorreo(
                    rs.getString("correo")
                );

                usuario.setRol(
                    rs.getString("rol")
                );

                usuario.setEstado(
                    rs.getInt("estado")
                );

                usuario.setFechaCreacion(
                    rs.getTimestamp("fecha_creacion")
                );

                usuario.setIntentosFallidos(
                    rs.getInt("intentos_fallidos")
                );

                usuario.setBloqueadoHasta(
                    rs.getTimestamp("bloqueado_hasta")
                );

                lista.add(usuario);
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar usuarios:"
            );

            e.printStackTrace();
        }

        return lista;
    }


    // =========================================================
    // INSERTAR USUARIO
    // =========================================================

    public boolean insertar(
            Usuario usuario) {

        String sqlId =
            "SELECT COALESCE(MAX(id_usuario), 0) + 1 " +
            "AS siguiente_id " +
            "FROM usuarios";

        String sql =
            "INSERT INTO usuarios " +
            "(id_usuario, nombre, apellido, usuario, password, " +
            "correo, rol, estado, fecha_creacion, " +
            "intentos_fallidos, bloqueado_hasta) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), 0, NULL)";

        try (Connection conexion =
                 Conexion.conectar()) {

            int siguienteId = 1;

            try (PreparedStatement psId =
                     conexion.prepareStatement(sqlId);
                 ResultSet rs =
                     psId.executeQuery()) {

                if (rs.next()) {

                    siguienteId =
                        rs.getInt("siguiente_id");
                }
            }

            try (PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

                ps.setInt(
                    1,
                    siguienteId
                );

                ps.setString(
                    2,
                    usuario.getNombre()
                );

                ps.setString(
                    3,
                    usuario.getApellido()
                );

                ps.setString(
                    4,
                    usuario.getUsuario()
                );

                ps.setString(
                    5,
                    usuario.getPassword()
                );

                ps.setString(
                    6,
                    usuario.getCorreo()
                );

                ps.setString(
                    7,
                    usuario.getRol()
                );

                ps.setInt(
                    8,
                    usuario.getEstado()
                );

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar usuario:"
            );

            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // CAMBIAR ESTADO DEL USUARIO
    // =========================================================

    public boolean cambiarEstado(
            int idUsuario,
            int nuevoEstado) {

        String sql =
            "UPDATE usuarios " +
            "SET estado = ? " +
            "WHERE id_usuario = ?";

        try (Connection conexion =
                 Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setInt(
                1,
                nuevoEstado
            );

            ps.setInt(
                2,
                idUsuario
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al cambiar el estado del usuario:"
            );

            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // ACTUALIZAR USUARIO
    // =========================================================

    public boolean actualizar(
            Usuario usuario) {

        if (usuario == null) {

            return false;
        }

        String sql =
            "UPDATE usuarios SET " +
            "nombre = ?, " +
            "apellido = ?, " +
            "usuario = ?, " +
            "password = ?, " +
            "correo = ?, " +
            "rol = ? " +
            "WHERE id_usuario = ?";

        try (Connection conexion =
                 Conexion.conectar();
             PreparedStatement ps =
                 conexion.prepareStatement(sql)) {

            ps.setString(
                1,
                usuario.getNombre()
            );

            ps.setString(
                2,
                usuario.getApellido()
            );

            ps.setString(
                3,
                usuario.getUsuario()
            );

            ps.setString(
                4,
                usuario.getPassword()
            );

            ps.setString(
                5,
                usuario.getCorreo()
            );

            ps.setString(
                6,
                usuario.getRol()
            );

            ps.setInt(
                7,
                usuario.getIdUsuario()
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar usuario:"
            );

            e.printStackTrace();

            return false;
        }
    }

}
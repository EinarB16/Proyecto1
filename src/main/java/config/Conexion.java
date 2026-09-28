package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL = "jdbc:mysql://localhost:3306/proyecto1";
    private static final String USUARIO = "root";
    private static final String PASSWORD = "";

    public static Connection conectar() {
        try {
            // Registra manualmente el driver JDBC de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
            System.out.println("Conexión exitosa con la base de datos.");
            return conexion;

        } catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver de MySQL en WEB-INF/lib.");
            System.out.println(e.getMessage());
            return null;
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos.");
            System.out.println(e.getMessage());
            return null;
        }
    }
}
package util;

public class GenerarPassword {

    public static void main(String[] args) {

        // Esta será la contraseña de prueba.
        String password = "123456";

        // Generamos el hash utilizando PBKDF2.
        String hash = PasswordUtil.generarHash(password);

        // Mostramos el resultado en la consola de Eclipse.
        System.out.println("Hash generado:");
        System.out.println(hash);
    }
}
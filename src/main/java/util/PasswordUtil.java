package util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.util.Base64;

public class PasswordUtil {

    // Cantidad de veces que se aplica el proceso de derivación.
    private static final int ITERACIONES = 65536;

    // Tamaño de la clave generada.
    private static final int LONGITUD_CLAVE = 256;

    // Tamaño del salt en bytes.
    private static final int LONGITUD_SALT = 16;


    // Genera un hash para una contraseña nueva.
    public static String generarHash(String password) {

        try {

            // Generamos un salt aleatorio.
            byte[] salt = new byte[LONGITUD_SALT];
            SecureRandom random = new SecureRandom();
            random.nextBytes(salt);

            // Convertimos la contraseña en una clave segura.
            PBEKeySpec spec = new PBEKeySpec(
                    password.toCharArray(),
                    salt,
                    ITERACIONES,
                    LONGITUD_CLAVE
            );

            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] hash = factory.generateSecret(spec).getEncoded();

            // Guardamos salt + hash en un solo texto.
            return Base64.getEncoder().encodeToString(salt)
                    + ":"
                    + Base64.getEncoder().encodeToString(hash);

        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {

            throw new RuntimeException("Error al generar el hash", e);
        }
    }


    // Comprueba si una contraseña coincide con un hash almacenado.
    public static boolean verificarPassword(String password, String hashGuardado) {

        try {

            // Separamos el salt y el hash.
            String[] partes = hashGuardado.split(":");

            byte[] salt = Base64.getDecoder().decode(partes[0]);
            byte[] hashOriginal = Base64.getDecoder().decode(partes[1]);

            // Generamos nuevamente el hash utilizando el mismo salt.
            PBEKeySpec spec = new PBEKeySpec(
                    password.toCharArray(),
                    salt,
                    ITERACIONES,
                    LONGITUD_CLAVE
            );

            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] hashNuevo = factory.generateSecret(spec).getEncoded();

            // Comparamos ambos resultados.
            return java.security.MessageDigest.isEqual(
                    hashOriginal,
                    hashNuevo
            );

        } catch (Exception e) {

            return false;
        }
    }
}
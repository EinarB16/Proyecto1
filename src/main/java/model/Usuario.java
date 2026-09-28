package model;

import java.sql.Timestamp;

public class Usuario {

    // Identificador del usuario en la base de datos.
    private int idUsuario;

    // Nombre del usuario.
    private String nombre;

    // Apellido del usuario.
    private String apellido;

    // Nombre utilizado para iniciar sesión.
    private String usuario;

    // Contraseña del usuario.
    // En la BD debe almacenarse como hash.
    private String password;

    // Correo electrónico.
    private String correo;

    // Rol del usuario dentro del sistema.
    private String rol;

    // Estado de la cuenta.
    // Según la BD: 1 = activo, 0 = inactivo.
    private int estado;

    // Fecha en que se creó el usuario.
    private Timestamp fechaCreacion;

    // Cantidad de intentos fallidos de inicio de sesión.
    private int intentosFallidos;

    // Fecha y hora hasta la cual la cuenta permanece bloqueada.
    private Timestamp bloqueadoHasta;


    // Constructor vacío.
    public Usuario() {
    }


    // Getter y setter del ID.
    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }


    // Getter y setter del nombre.
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }


    // Getter y setter del apellido.
    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }


    // Getter y setter del usuario.
    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }


    // Getter y setter de la contraseña.
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    // Getter y setter del correo.
    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }


    // Getter y setter del rol.
    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }


    // Getter y setter del estado.
    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }


    // Getter y setter de la fecha de creación.
    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }


    // Getter y setter de los intentos fallidos.
    public int getIntentosFallidos() {
        return intentosFallidos;
    }

    public void setIntentosFallidos(int intentosFallidos) {
        this.intentosFallidos = intentosFallidos;
    }


    // Getter y setter de la fecha de bloqueo.
    public Timestamp getBloqueadoHasta() {
        return bloqueadoHasta;
    }

    public void setBloqueadoHasta(Timestamp bloqueadoHasta) {
        this.bloqueadoHasta = bloqueadoHasta;
    }
}
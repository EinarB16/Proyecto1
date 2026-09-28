package model;

public class Proveedor {

    private int idProveedor;
    private String nombre;
    private String telefono;
    private String correo;
    private int estado;
    private String ruc;


    // Constructor vacío.
    public Proveedor() {
    }


    // Obtiene el ID del proveedor.
    public int getIdProveedor() {
        return idProveedor;
    }

    // Establece el ID del proveedor.
    public void setIdProveedor(int idProveedor) {
        this.idProveedor = idProveedor;
    }


    // Obtiene el nombre del proveedor.
    public String getNombre() {
        return nombre;
    }

    // Establece el nombre del proveedor.
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }


    // Obtiene el teléfono del proveedor.
    public String getTelefono() {
        return telefono;
    }

    // Establece el teléfono del proveedor.
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }


    // Obtiene el correo del proveedor.
    public String getCorreo() {
        return correo;
    }

    // Establece el correo del proveedor.
    public void setCorreo(String correo) {
        this.correo = correo;
    }


    // Obtiene el estado del proveedor.
    public int getEstado() {
        return estado;
    }

    // Establece el estado del proveedor.
    public void setEstado(int estado) {
        this.estado = estado;
    }


    // Obtiene el RUC del proveedor.
    public String getRuc() {
        return ruc;
    }

    // Establece el RUC del proveedor.
    public void setRuc(String ruc) {
        this.ruc = ruc;
    }
}
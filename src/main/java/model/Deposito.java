package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Deposito {

    // Identificador del depósito
    private int idDeposito;

    // Número del comprobante del depósito
    private String numeroComprobante;

    // Tipo de depósito:
    // 1 = Transferencia
    // 2 = Depósito directo
    private int tipoDeposito;

    // Fecha en que se realizó el depósito
    private Date fecha;

    // Monto del depósito
    private double monto;

    // Detalle o descripción del depósito
    private String detalle;

    // Estado:
    // 1 = Activo
    // 0 = Inactivo
    private int estado;

    // Usuario que registró el depósito
    private int idUsuario;

    // Fecha y hora en que se registró
    private Timestamp fechaRegistro;


    // Constructor vacío
    public Deposito() {
    }


    // Constructor completo
    public Deposito(int idDeposito, String numeroComprobante,
                    int tipoDeposito, Date fecha, double monto,
                    String detalle, int estado, int idUsuario,
                    Timestamp fechaRegistro) {

        this.idDeposito = idDeposito;
        this.numeroComprobante = numeroComprobante;
        this.tipoDeposito = tipoDeposito;
        this.fecha = fecha;
        this.monto = monto;
        this.detalle = detalle;
        this.estado = estado;
        this.idUsuario = idUsuario;
        this.fechaRegistro = fechaRegistro;
    }


    // Getters y Setters

    public int getIdDeposito() {
        return idDeposito;
    }

    public void setIdDeposito(int idDeposito) {
        this.idDeposito = idDeposito;
    }


    public String getNumeroComprobante() {
        return numeroComprobante;
    }

    public void setNumeroComprobante(String numeroComprobante) {
        this.numeroComprobante = numeroComprobante;
    }


    public int getTipoDeposito() {
        return tipoDeposito;
    }

    public void setTipoDeposito(int tipoDeposito) {
        this.tipoDeposito = tipoDeposito;
    }


    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }


    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }


    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }


    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }


    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }


    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}
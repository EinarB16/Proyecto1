package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Cheque {

    private int idCheque;
    private String numeroCheque;
    private Date fechaCheque;
    private int idProveedor;
    private double monto;
    private String montoLetras;
    private String detalle;
    private int idObjetoGasto;
    private int estado;
    private Timestamp fechaAnulacion;
    private String motivoAnulacion;
    private Timestamp fechaSalidaCirculacion;
    private String observacionSalida;
    private int idUsuarioCreacion;
    private Integer idUsuarioAnulacion;
    private String nombreProveedor;
    private String descripcionObjetoGasto;

    public String getNombreProveedor() {
        return nombreProveedor;
    }

    public void setNombreProveedor(String nombreProveedor) {
        this.nombreProveedor = nombreProveedor;
    }

    public String getDescripcionObjetoGasto() {
        return descripcionObjetoGasto;
    }

    public void setDescripcionObjetoGasto(String descripcionObjetoGasto) {
        this.descripcionObjetoGasto = descripcionObjetoGasto;
    }


    // Constructor vacío.
    public Cheque() {
    }


    // Obtiene el ID del cheque.
    public int getIdCheque() {
        return idCheque;
    }

    // Establece el ID del cheque.
    public void setIdCheque(int idCheque) {
        this.idCheque = idCheque;
    }


    // Obtiene el número del cheque.
    public String getNumeroCheque() {
        return numeroCheque;
    }

    // Establece el número del cheque.
    public void setNumeroCheque(String numeroCheque) {
        this.numeroCheque = numeroCheque;
    }


    // Obtiene la fecha del cheque.
    public Date getFechaCheque() {
        return fechaCheque;
    }

    // Establece la fecha del cheque.
    public void setFechaCheque(Date fechaCheque) {
        this.fechaCheque = fechaCheque;
    }


    // Obtiene el ID del proveedor.
    public int getIdProveedor() {
        return idProveedor;
    }

    // Establece el ID del proveedor.
    public void setIdProveedor(int idProveedor) {
        this.idProveedor = idProveedor;
    }


    // Obtiene el monto del cheque.
    public double getMonto() {
        return monto;
    }

    // Establece el monto del cheque.
    public void setMonto(double monto) {
        this.monto = monto;
    }


    // Obtiene el monto escrito en letras.
    public String getMontoLetras() {
        return montoLetras;
    }

    // Establece el monto escrito en letras.
    public void setMontoLetras(String montoLetras) {
        this.montoLetras = montoLetras;
    }


    // Obtiene el detalle del cheque.
    public String getDetalle() {
        return detalle;
    }

    // Establece el detalle del cheque.
    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }


    // Obtiene el ID del objeto de gasto.
    public int getIdObjetoGasto() {
        return idObjetoGasto;
    }

    // Establece el ID del objeto de gasto.
    public void setIdObjetoGasto(int idObjetoGasto) {
        this.idObjetoGasto = idObjetoGasto;
    }


    // Obtiene el estado actual del cheque.
    public int getEstado() {
        return estado;
    }

    // Establece el estado del cheque.
    public void setEstado(int estado) {
        this.estado = estado;
    }


    // Obtiene la fecha de anulación.
    public Timestamp getFechaAnulacion() {
        return fechaAnulacion;
    }

    // Establece la fecha de anulación.
    public void setFechaAnulacion(Timestamp fechaAnulacion) {
        this.fechaAnulacion = fechaAnulacion;
    }


    // Obtiene el motivo de anulación.
    public String getMotivoAnulacion() {
        return motivoAnulacion;
    }

    // Establece el motivo de anulación.
    public void setMotivoAnulacion(String motivoAnulacion) {
        this.motivoAnulacion = motivoAnulacion;
    }


    // Obtiene la fecha en que el cheque salió de circulación.
    public Timestamp getFechaSalidaCirculacion() {
        return fechaSalidaCirculacion;
    }

    // Establece la fecha en que el cheque salió de circulación.
    public void setFechaSalidaCirculacion(Timestamp fechaSalidaCirculacion) {
        this.fechaSalidaCirculacion = fechaSalidaCirculacion;
    }


    // Obtiene la observación de la salida de circulación.
    public String getObservacionSalida() {
        return observacionSalida;
    }

    // Establece la observación de la salida de circulación.
    public void setObservacionSalida(String observacionSalida) {
        this.observacionSalida = observacionSalida;
    }


    // Obtiene el ID del usuario que creó el cheque.
    public int getIdUsuarioCreacion() {
        return idUsuarioCreacion;
    }

    // Establece el ID del usuario que creó el cheque.
    public void setIdUsuarioCreacion(int idUsuarioCreacion) {
        this.idUsuarioCreacion = idUsuarioCreacion;
    }


    // Obtiene el ID del usuario que anuló el cheque.
    // Se utiliza Integer porque este campo puede ser NULL.
    public Integer getIdUsuarioAnulacion() {
        return idUsuarioAnulacion;
    }

    // Establece el ID del usuario que anuló el cheque.
    public void setIdUsuarioAnulacion(Integer idUsuarioAnulacion) {
        this.idUsuarioAnulacion = idUsuarioAnulacion;
    }
}
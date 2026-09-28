package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

// Modelo que representa una conciliación bancaria.
public class Conciliacion {

    // Identificador de la conciliación.
    private int idConciliacion;

    // Periodo de la conciliación, por ejemplo: 2026-09.
    private String periodo;

    // Saldo registrado en los libros.
    private BigDecimal saldoLibros;

    // Depósitos que todavía están en tránsito.
    private BigDecimal depositosTransito;

    // Total de cheques pendientes.
    private BigDecimal chequesPendientes;

    // Saldo informado por el banco.
    private BigDecimal saldoBanco;

    // Diferencia entre el saldo conciliado y el saldo bancario.
    private BigDecimal diferencia;

    // Fecha en que se realizó la conciliación.
    private Timestamp fechaConciliacion;

    // Estado de la conciliación.
    // 1 = En proceso
    // 2 = Ajustada
    // 3 = Verificada
    // 4 = Cerrada
    private int estado;

    // Usuario que realizó la conciliación.
    private int idUsuario;

    // Observaciones adicionales.
    private String observaciones;


    // =========================================================
    // CONSTRUCTOR VACÍO
    // =========================================================

    public Conciliacion() {
    }


    // =========================================================
    // GETTERS Y SETTERS
    // =========================================================

    public int getIdConciliacion() {
        return idConciliacion;
    }

    public void setIdConciliacion(int idConciliacion) {
        this.idConciliacion = idConciliacion;
    }


    public String getPeriodo() {
        return periodo;
    }

    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }


    public BigDecimal getSaldoLibros() {
        return saldoLibros;
    }

    public void setSaldoLibros(BigDecimal saldoLibros) {
        this.saldoLibros = saldoLibros;
    }


    public BigDecimal getDepositosTransito() {
        return depositosTransito;
    }

    public void setDepositosTransito(BigDecimal depositosTransito) {
        this.depositosTransito = depositosTransito;
    }


    public BigDecimal getChequesPendientes() {
        return chequesPendientes;
    }

    public void setChequesPendientes(BigDecimal chequesPendientes) {
        this.chequesPendientes = chequesPendientes;
    }


    public BigDecimal getSaldoBanco() {
        return saldoBanco;
    }

    public void setSaldoBanco(BigDecimal saldoBanco) {
        this.saldoBanco = saldoBanco;
    }


    public BigDecimal getDiferencia() {
        return diferencia;
    }

    public void setDiferencia(BigDecimal diferencia) {
        this.diferencia = diferencia;
    }


    public Timestamp getFechaConciliacion() {
        return fechaConciliacion;
    }

    public void setFechaConciliacion(Timestamp fechaConciliacion) {
        this.fechaConciliacion = fechaConciliacion;
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


    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
}
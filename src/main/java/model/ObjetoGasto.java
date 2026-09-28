// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package model;

import java.sql.Timestamp;

public class ObjetoGasto {
   private int idObjetoGasto;
   private String codigo;
   private String descripcion;
   private int estado;
   private Timestamp fechaCreacion;

   public ObjetoGasto() {
   }

   public int getIdObjetoGasto() {
      return this.idObjetoGasto;
   }

   public void setIdObjetoGasto(int idObjetoGasto) {
      this.idObjetoGasto = idObjetoGasto;
   }

   public String getCodigo() {
      return this.codigo;
   }

   public void setCodigo(String codigo) {
      this.codigo = codigo;
   }

   public String getDescripcion() {
      return this.descripcion;
   }

   public void setDescripcion(String descripcion) {
      this.descripcion = descripcion;
   }

   public int getEstado() {
      return this.estado;
   }

   public void setEstado(int estado) {
      this.estado = estado;
   }

   public Timestamp getFechaCreacion() {
      return this.fechaCreacion;
   }

   public void setFechaCreacion(Timestamp fechaCreacion) {
      this.fechaCreacion = fechaCreacion;
   }
}

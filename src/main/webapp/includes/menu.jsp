<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contexto = request.getContextPath();
%>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Botón para abrir/cerrar el menú -->
<button class="btn btn-primary menu-boton" type="button"
        onclick="
            document.getElementById('menuLateral').classList.toggle('menu-abierto');
            document.body.classList.toggle('menu-expandido');
        ">
    <i class="bi bi-list"></i>
</button>

<!-- Menú lateral -->
<div id="menuLateral" class="menu-lateral">

    <div class="menu-titulo">
        <!-- Espacio reservado para el logo -->
    </div>

    <a href="<%= contexto %>/DashboardServlet">
        <span><i class="bi bi-house-door-fill"></i></span>
        <span class="menu-texto">Dashboard</span>
    </a>

    <a href="<%= contexto %>/ChequeServlet">
        <span><i class="bi bi-cash-stack"></i></span>
        <span class="menu-texto">Cheques</span>
    </a>

    <a href="<%= contexto %>/DepositoServlet">
        <span><i class="bi bi-piggy-bank-fill"></i></span>
        <span class="menu-texto">Depósitos</span>
    </a>

    <a href="<%= contexto %>/ConciliacionServlet">
        <span><i class="bi bi-bank2"></i></span>
        <span class="menu-texto">Conciliación</span>
    </a>

    <a href="<%= contexto %>/ReporteServlet">
        <span><i class="bi bi-bar-chart-line-fill"></i></span>
        <span class="menu-texto">Consultas / Reportes</span>
    </a>

    <a href="<%= contexto %>/ProveedorServlet">
        <span><i class="bi bi-people-fill"></i></span>
        <span class="menu-texto">Proveedores</span>
    </a>

    <a href="<%= contexto %>/ObjetoGastoServlet">
        <span><i class="bi bi-list-check"></i></span>
        <span class="menu-texto">Objetos de gasto</span>
    </a>
    
<%
    // Obtenemos el usuario que inició sesión
    model.Usuario usuarioMenu =
        (model.Usuario) session.getAttribute("usuario");

    // Solo mostramos Usuarios si tiene rol ADMIN
    if (usuarioMenu != null &&
        "administrador".equalsIgnoreCase(usuarioMenu.getRol())) {
%>

    <a href="<%= contexto %>/UsuarioServlet">
        <span><i class="bi bi-person-badge-fill"></i></span>
        <span class="menu-texto">Usuarios</span>
    </a>

<%
    }
%>
    <hr>

    <a href="<%= contexto %>/LogoutServlet">
        <span><i class="bi bi-box-arrow-right"></i></span>
        <span class="menu-texto">Salir</span>
    </a>

</div>

<style>

    /* Botón ☰ */
    .menu-boton {
        position: fixed;
        top: 15px;
        left: 15px;
        z-index: 1051;
        font-size: 22px;
        width: 50px;
        height: 45px;
    }

    /* Menú cerrado */
    .menu-lateral {
        position: fixed;
        top: 0;
        left: 0;
        width: 70px;
        height: 100vh;
        background-color: #212529;
        padding-top: 75px;
        z-index: 1050;
        transition: width 0.3s ease;
        overflow: hidden;
    }

    /* Menú abierto */
    .menu-lateral.menu-abierto {
        width: 250px;
    }

    /* Título */
    .menu-titulo {
    color: white;
    padding: 15px 20px;
    white-space: nowrap;
    border-bottom: 1px solid #495057;
    margin-bottom: 10px;
    opacity: 0;
    transition: opacity 0.2s;
	}
	
	/* Mostrar título solamente cuando el menú está abierto */
	.menu-lateral.menu-abierto .menu-titulo {
	    opacity: 1;
	}

    /* Enlaces */
    .menu-lateral a {
        display: flex;
        align-items: center;
        height: 50px;
        padding: 0 20px;
        color: white;
        text-decoration: none;
        white-space: nowrap;
        transition: background-color 0.2s;
    }

    .menu-lateral a:hover {
        background-color: #495057;
    }

    /* Iconos */
    .menu-lateral a span:first-child {
        min-width: 30px;
        font-size: 20px;
    }

    /* Texto */
    .menu-texto {
        margin-left: 10px;
        opacity: 0;
        transition: opacity 0.2s;
    }

    /* Mostrar texto cuando está abierto */
    .menu-lateral.menu-abierto .menu-texto {
        opacity: 1;
    }

    /* Línea */
    .menu-lateral hr {
        border-color: #6c757d;
        margin: 10px 15px;
    }
    
    /* La barra superior deja espacio para el menú */
.barra-superior {
    margin-left: 70px;
    transition: margin-left 0.3s ease;
}

/* Cuando el menú se abre */
.menu-expandido .barra-superior {
    margin-left: 250px;
}

/* El contenido también deja espacio para el menú */
.contenido-principal {
    margin-left: 70px;
    transition: margin-left 0.3s ease;
}

/* Cuando el menú se abre */
.menu-expandido .contenido-principal {
    margin-left: 250px;
}

</style>
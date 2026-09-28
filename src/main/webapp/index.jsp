<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!--
    Este archivo es la ÚNICA página real que el navegador carga.
    Todo el resto del sistema (login, dashboard, cheques,
    depósitos, etc.) vive DENTRO del iframe de abajo.

    Por eso la URL de arriba del navegador nunca cambia:
    el navegador nunca navega de verdad, solo el iframe
    interno va cambiando de contenido.
-->

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Conciliación Bancaria</title>
    <style>
        /* Quitamos márgenes y hacemos que el iframe ocupe
           toda la pantalla, sin barras de scroll extrañas. */
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        #contenidoApp {
            display: block;
            width: 100%;
            height: 100vh;
            border: none;
        }
    </style>
</head>
<body>

    <!--
        Todo el sistema arranca aquí, mostrando el login.
        El "name" es importante: los formularios y links de
        adentro navegan dentro de este iframe automáticamente,
        sin necesidad de tocar ningún otro archivo del proyecto.
    -->
    <iframe id="contenidoApp"
            name="contenidoApp"
            src="<%= request.getContextPath() %>/views/login.jsp"
            title="Conciliación Bancaria">
    </iframe>

    <script>
        // =====================================================
        // BLOQUEAR ATRÁS / ADELANTE DEL NAVEGADOR
        // =====================================================
        // Cada vez que el iframe termina de cargar una página
        // nueva, "clonamos" esa entrada en el historial. Así,
        // si el usuario presiona Atrás, el navegador solo se
        // mueve entre dos copias de la MISMA página (no pasa
        // nada visualmente), y volvemos a clonar de inmediato
        // para quedar atrapados ahí otra vez.

        const iframeApp = document.getElementById("contenidoApp");

        function atraparHistorial() {

            try {
                const ventanaInterna = iframeApp.contentWindow;

                // Duplicamos la entrada actual.
                ventanaInterna.history.pushState(
                    null,
                    "",
                    ventanaInterna.location.href
                );

                // Si el usuario presiona Atrás o Adelante,
                // lo regresamos aquí mismo de inmediato.
                ventanaInterna.onpopstate = function () {

                    ventanaInterna.history.pushState(
                        null,
                        "",
                        ventanaInterna.location.href
                    );
                };

            } catch (error) {
                // Si por algo no se puede acceder (por ejemplo,
                // la página aún no cargó del todo), lo ignoramos.
            }
        }

        // Volvemos a aplicar la trampa cada vez que el iframe
        // carga una pantalla nueva (login, dashboard, cheques...).
        iframeApp.addEventListener("load", atraparHistorial);
    </script>

</body>
</html>
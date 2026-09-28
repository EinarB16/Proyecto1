console.log("funciones.js se cargó correctamente");
// Convierte un número entero en palabras
function numeroEnLetras(numero) {

    // Caso especial para cero
    if (numero === 0) {
        return "CERO";
    }

    const unidades = [
        "", "UNO", "DOS", "TRES", "CUATRO",
        "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE"
    ];

    const especiales = [
        "DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE",
        "QUINCE", "DIECISÉIS", "DIECISIETE",
        "DIECIOCHO", "DIECINUEVE"
    ];

    const decenas = [
        "", "", "VEINTE", "TREINTA", "CUARENTA",
        "CINCUENTA", "SESENTA", "SETENTA",
        "OCHENTA", "NOVENTA"
    ];

    const centenas = [
        "", "CIENTO", "DOSCIENTOS", "TRESCIENTOS",
        "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS",
        "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS"
    ];

    // Convierte números del 1 al 999
    function convertirGrupo(n) {

        if (n === 0) return "";

        if (n < 10) {
            return unidades[n];
        }

        if (n < 20) {
            return especiales[n - 10];
        }

        if (n < 100) {
            let decena = Math.floor(n / 10);
            let unidad = n % 10;

            if (decena === 2 && unidad > 0) {
                return "VEINTI" + unidades[unidad];
            }

            return decenas[decena] +
                (unidad > 0 ? " Y " + unidades[unidad] : "");
        }

        if (n === 100) {
            return "CIEN";
        }

        let centena = Math.floor(n / 100);
        let resto = n % 100;

        return centenas[centena] +
            (resto > 0 ? " " + convertirGrupo(resto) : "");
    }

    // Millones y miles
    if (numero < 1000) {
        return convertirGrupo(numero);
    }

    if (numero < 1000000) {

        let miles = Math.floor(numero / 1000);
        let resto = numero % 1000;

        let textoMiles = miles === 1
            ? "MIL"
            : convertirGrupo(miles) + " MIL";

        return textoMiles +
            (resto > 0 ? " " + convertirGrupo(resto) : "");
    }

    if (numero < 1000000000) {

        let millones = Math.floor(numero / 1000000);
        let resto = numero % 1000000;

        let textoMillones = millones === 1
            ? "UN MILLÓN"
            : convertirGrupo(millones) + " MILLONES";

        if (resto > 0) {
            let miles = Math.floor(resto / 1000);
            let unidadesRestantes = resto % 1000;

            if (miles > 0) {
                textoMillones += " " +
                    (miles === 1 ? "MIL" : convertirGrupo(miles) + " MIL");
            }

            if (unidadesRestantes > 0) {
                textoMillones += " " +
                    convertirGrupo(unidadesRestantes);
            }
        }

        return textoMillones;
    }

    return "MONTO DEMASIADO GRANDE";
}


// Convierte el monto completo a letras
function convertirMontoLetras(monto) {

    // Si no hay monto, no hacemos nada
    if (!monto || monto <= 0) {
        return "";
    }

    // Separamos la parte entera y los centavos
    let partes = monto.toFixed(2).split(".");

    let entero = parseInt(partes[0]);
    let centavos = partes[1];

    // Convertimos la parte entera
    let letras = numeroEnLetras(entero);

    // Formato final
    return letras + " BALBOAS CON " + centavos + "/100";
}


// Esperamos a que la página termine de cargar
document.addEventListener("DOMContentLoaded", function () {

    // Buscamos el campo donde se escribe el monto
    const campoMonto = document.getElementById("monto");

    // Buscamos el campo donde aparecerá el monto en letras
    const campoMontoLetras = document.getElementById("montoLetras");

    // Si los campos existen, agregamos el funcionamiento
    if (campoMonto && campoMontoLetras) {

        // Cada vez que cambie el monto, lo convertimos
        campoMonto.addEventListener("input", function () {

            campoMontoLetras.value =
                convertirMontoLetras(parseFloat(campoMonto.value));

        });
    }
});

// =========================================================
// BLOQUEAR "e", "E", "+", "-" EN CAMPOS NUMÉRICOS
// =========================================================
// Por defecto, <input type="number"> acepta notación
// científica (ej: "1e3" = 1000) y el signo "+"/"-" sueltos.
// Esto bloquea esas teclas y también lo que se pegue con
// el mouse (Ctrl+V) en cualquier input numérico de la página.

document.addEventListener("DOMContentLoaded", function () {

    const camposNumericos =
        document.querySelectorAll("input[type='number']");

    camposNumericos.forEach(function (campo) {

        // Bloquea las teclas prohibidas mientras se escribe
        campo.addEventListener("keydown", function (evento) {

            if (["e", "E", "+", "-"].includes(evento.key)) {
                evento.preventDefault();
            }
        });

        // Limpia lo que se pegue (Ctrl+V) si trae esos caracteres
        campo.addEventListener("paste", function (evento) {

            const texto =
                (evento.clipboardData || window.clipboardData)
                    .getData("text");

            if (/[eE+\-]/.test(texto)) {
                evento.preventDefault();
            }
        });
    });
});
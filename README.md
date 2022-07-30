#Control remoto por RS232 para Winamp
Controlador IR Winamp de bajo costo

Este proyecto aquí presenta la forma más básica de transmisión de datos por infrarrojos (IR). Los rayos IR se utilizan principalmente en los controles remotos para el televisor, el reproductor de DVD, el control del calentador/aire acondicionado, etc. ya que a veces soy demasiado perezoso para caminar hasta la PC y cambiar el volumen, las pistas y otras cosas. Oh, sí, mi computadora también es mi sistema de cine en casa. Así que me digo, ¿por qué no hacerlo desde lejos, donde puedo seguir leyendo los periódicos mientras escucho música? =P

Comencé con la búsqueda de un control remoto antiguo adecuado que ya no quería.
Y así comenzó la búsqueda para construir el controlador IR reemplazando primero la placa de circuito original con la mía. La placa contiene un PIC16F627, una puerta OR 74LS32, transistores PNP 2N3906, un regulador 78L05, cristal de 4 MHz y un LED IR junto con algunos botones pulsadores.
Debido a la cantidad limitada de espacio, la mayoría de los cableados se realizan en el reverso de la placa... sí, un cableado loco y desordenado.

La nueva placa de circuito está instalada en la antigua carcasa del control remoto Hitachi VCR y, sorprendentemente, encajaba casi a la perfección. Tuve que cortar un poco los bordes dentro de la carcasa para hacer un poco más de espacio para los botones.

El módulo receptor IR está conectado al puerto serie de la computadora. Intercepta el transmisor de señal del controlador IR y lo traduce a comandos de Winamp. Winamp tiene una lista de teclas de acceso rápido global que se puede usar desde cualquier lugar de Windows para controlar Winamp. El programa Visual Basic básicamente genera estos códigos de escaneo de teclado para acceder a las teclas rápidas globales de Winamp.

Antes de que el receptor IR pueda usarse para controlar Winamp, primero se deben habilitar las teclas de acceso rápido globales.
Los diagramas de tiempo de la transmisión de datos desde el PIC al módulo receptor IR se muestran en el adjunto.

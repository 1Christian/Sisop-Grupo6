##############################################################################################
##############################################################################################
###    Programa: Sisop-Grupo6                                                              ###
###    Creadores: Christian Fabián Torres, Gabriel La Torre, Ignacio Martín Maness         ###
###    TP-Grupo6-Sprint1                                                                   ###
###    Año: 2017                                                                           ###
##############################################################################################
##############################################################################################


##############################################
#### REQUISITOS PARA EL USO DEL PROGRAMA: ####
##############################################

- PERL v5+
- Git

################################
#### INSTRUCCIIONES DE USO: ####
################################

**************
** DESCARGA **
**************

1) Descargar el archivo comprimido desde https://github.com/1Christian/Sisop-Grupo6 o desde el USB provisto por los alumnos.




********************
** DESCROMPRESIÓN **
********************

2) Descomprimir el archivo ejecutando el siguiente comando en la consola (ubicado en el directorio en el que se encuentra el archivo comprimido): 

>	$ tar -xvzf Grupo06.tgz

Luego de la descrompresión, se creará el directorio: "Grupo06", el cual contendrá:

- Instalador.sh
- Inicializador.sh
- Demonio.sh
- Utilidades.sh
- /dirconf
- /DIRMAE (Directorio donde se alojan los archivos maestros).




*****************
** INSTALACIÓN **
*****************

3) Otorgar el permiso de ejecución para el instalador, que luego de la extracción se encontrará en el directorio de ejecutables, p.e.: /bin, de la siguiente manera:

>	chmod +x ./Instalador.sh

4) Para llevar a cabo la instalación se puede ejecutar el script con ó sin opciones, las cuales se detallan a continaución: 

>	./Instalador.sh (Instalación básica)
>	./Instalador.sh -t (Permite detectar si el sistema se encuentra instalado, en cuyo caso muestra la configuración de la instalación previa)
>	./Instalador.sh -i (Permite instalar/reinstalar el programa, en caso de una reinstalación no se podrán definir nombres nuevos para los directorios, se deberán respetar los que ya se encuentren creados. Por otro lado permite la reparación de una instalación defectuosa)

5) Seguir los pasos indicados en la consola. Al finalizar la instalación, dentro del directorio en el que hayamos descromprimido el programa, quedará creada la estructura de directorios como se muestra a continuación:

- DIRCONF=/usr/temp/Grupo06/dirconf
- BINARIOS=/usr/temp/Grupo06/bin
- MAESTROS=/usr/temp/Grupo06/mae
- NOVEDADES=/usr/temp/Grupo06/nov
- ACEPTADOS=/usr/temp/Grupo06/ok
- RECHAZADOS=/usr/temp/Grupo06/nok
- VALIDADOS=/usr/temp/Grupo06/listos
- REPORTES=/usr/temp/Grupo06/rep
- LOG=/usr/temp/Grupo06/log




*********************
** INICIALIZACIÓN: **
*********************

6) Para comenzar el uso del sistema, ejecutar el comando Inicializador.sh presente en la carpeta de ejecutables (p.e.: /usr/temp/Grupo06/bin/Inicializador.sh) de la siguiente forma: 

>	./bin/Inicializador.sh

Esto inicializará las variables del programa y seteará los permisos a todos los archivos que lo requieran para su correcta ejecución y edición.

7) Luego de la inicialización se podrá optar por iniciar Demonio.sh automáticamente o se darán las instrucciones necesarias para hacerlo manualmente.




***************
** PROCESOS: **
***************

8) El Demonio se podrá ejecutar automáticamente como se especificó en el punto anterior ó, ejecutarlo manualmente a través de las utilidades brindadas por el programa (se describirá más adelante).

9) El Demonio es un proceso que una vez que se ejecute ciclicamente en busca de novedades para validar.

10) El Demonio dispondrá de las opciones: Start y Stop para iniciar el proceso o detenerlo correspondientemente. El uso de las mismas está descripto a continuación:

>	./bin/Demonio.sh start
>	./bin/Demonio.sh stop




****************************************
** COMANDO DE VALIDACIÓN DE ACEPTADOS **
****************************************

11) Se provee de la ejecución de un proceso invocado por el Demonio.sh que simule la validación de archivos.




****************
** UTILIDADES **
****************

12) El programa cuanta con la posibilidad de iniciar o detener procesos mediante la ejecución del script: Utilidades.sh, p.e.:

> ./bin/Utilidades.sh start Demonio.sh
> ./bin/Utilidades.sh stop Demonio.sh

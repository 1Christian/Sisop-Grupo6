#!/bin/bash

###########################################################################################################
################################################ REGION: VARIABLES ########################################
###########################################################################################################

GRUPO=$(pwd)"/"
ARCH_CNF="Instalador.conf"
WHERE="Instalador"
CONFDIR="$GRUPO""dirconf/"
DIRBIN="$GRUPO""bin/"
DIRMAE="$GRUPO""mae/"
DIRNOV="$GRUPO""nov/"
DIROK="$GRUPO""ok/"
DIRNOK="$GRUPO""nok/"
DIRVAL="$GRUPO""listos/"
DIRREP="$GRUPO""rep/"
DIRLOG="$GRUPO""log/"
ARCH_LOG="Instalador.log"
WHAT="INF"
LOGSIZE=1024



###########################################################################################################
################################################ REGION: MÉTODOS ##########################################
###########################################################################################################

Loguear() {
	WHEN=$(date "+%Y%m%d %H:%M:%S")
	echo "$WHEN-$USER-$WHERE-$1-$2" >> "$ARCH_LOG"  
}

reinstalar(){
	echo "~ Inicio de la reinstalación del sistema ~"
	Loguear "INF" "Inicio de la reinstalación del sistema"
	if [ ! -d $CONFDIR ]
	  then
		echo "Directorio de Configuracion: $CONFDIR"
		Loguear "INF" "Directorio de Configuracion: $CONFDIR"
		mkdir --parents "$CONFDIR"
	  else
		echo "Directorio de Configuracion: $CONFDIR ya existe"
		Loguear "INF" "Directorio de Configuracion: $CONFDIR ya existe"
	fi
	if [ ! -d $DIRBIN ]
	  then
		echo "Directorio de Ejecutables: $DIRBIN"
		Loguear "INF" "Directorio de Ejecutables: $DIRBIN"
		mkdir --parents "$DIRBIN"
	  else
		echo "Directorio de Ejecutables: $DIRBIN ya existe"
		Loguear "INF" "Directorio de Ejecutables: $DIRBIN ya existe"
	fi
	if [ ! -d $DIRMAE ]
	  then
		echo "Directorio de Maestros y Tablas: $DIRMAE"
		Loguear "INF" "Directorio de Maestros y Tablas: $DIRMAE"
		mkdir --parents "$DIRMAE"
	  else
		echo "Directorio de Maestros y Tablas: $DIRMAE ya existe"
		Loguear "INF" "Directorio de Maestros y Tablas: $DIRMAE ya existe"
	fi
	if [ ! -d $DIRNOV ]
	  then
		echo "Directorio de Recepción de Novedades: $DIRNOV"
		Loguear "INF" "Directorio de Recepción de Novedades: $DIRNOV"
		mkdir --parents "$DIRNOV"
	  else
		echo "Directorio de Recepción de Novedades: $DIRNOV ya existe"
		Loguear "INF" "Directorio de Recepción de Novedades: $DIRNOV ya existe"
	fi
	if [ ! -d $DIROK ]
	  then
		echo "Directorio de Archivos Aceptados: $DIROK"
		Loguear "INF" "Directorio de Archivos Aceptados: $DIROK"
		mkdir --parents "$DIROK"
	  else
		echo "Directorio de Archivos Aceptados: $DIROK ya existe"
		Loguear "INF" "Directorio de Archivos Aceptados: $DIROK ya existe"
	fi
	if [ ! -d $DIRNOK ]
	  then
		echo "Directorio de Rechazados: $DIRNOK"
		Loguear "INF" "Directorio de Rechazados: $DIRNOK"
		mkdir --parents "$DIRNOK"
	  else
		echo "Directorio de Rechazados: $DIRNOK ya existe"
		Loguear "INF" "Directorio de Rechazados: $DIRNOK ya existe"
	fi
	if [ ! -d $DIRVAL ]
	  then
		echo "Directorio de Archivos Validados: $DIRVAL"
		Loguear "INF" "Directorio de Archivos Validados: $DIRVAL"
		mkdir --parents "$DIRVAL"
	  else
		echo "Directorio de Archivos Validados: $DIRVAL ya existe"
		Loguear "INF" "Directorio de Archivos Validados: $DIRVAL ya existe"
	fi
	if [ ! -d $DIRREP ]
	  then
		echo "Directorio de Archivos de Reporte: $DIRREP"
		Loguear "INF" "Directorio de Archivos de Reporte: $DIRREP"
		mkdir --parents "$DIRREP"
	  else
		echo "Directorio de Archivos de Reporte: $DIRREP ya existe"
		Loguear "INF" "Directorio de Archivos de Reporte: $DIRREP ya existe"
	fi
	if [ ! -d $DIRLOG ]
	  then
		echo "Directorio de Log: $DIRLOG"
		Loguear "INF" "Directorio de Log: $DIRLOG"
		mkdir --parents "$DIRLOG"
	  else
		echo "Directorio de Log: $DIRLOG ya existe"
		Loguear "INF" "Directorio de Log: $DIRLOG ya existe"
	fi
	
}

chequeoVersionPerl(){
	echo "Chequeo de la version de Perl"
	Loguear "INF" "Chequeo de la version de Perl."
	if [[ $(perl -v|grep -o -m 1 '[0-9]'|head -1) -lt 5 ]]
	then 
		echo "La version es inferior a 5."
		Loguear "WAR" "La version es inferior a 5."				
	else 
		echo "La version es es correcta."
		Loguear "INF" "La version es correcta."
	fi
}

update_reserved() {
  RESERVED="$CONFDIR $DIRBIN $DIRMAE $DIRREP $DIROK $DIRNOV $DIRVAL $DIRLOG $DIRNOK" 
}

request_dirpath() {
  	update_reserved
  	local VALID="N"  
  	while [ $VALID == "N" ]; do
	    ## Prompt for directory
	    read -p "$1" UINPUT

	    if [ ! -z "$UINPUT" -a "$UINPUT" != " " -a "${UINPUT: -1}" != "/" ]; then
		UINPUT="$UINPUT/"
	    fi

	    Loguear "INF" "$1 $UINPUT"
	    ## Validate user input
	    if [ ! -z "$UINPUT" -a "$UINPUT" != " " ]; then
    	 	VALID="Y"
     		for rname in $RESERVED; do
				if [ "$GRUPO$UINPUT" == $rname ]; then
	  				echo -e "\n# El nombre $GRUPO$UINPUT se encuentra reservado\n" >&2
	  				Loguear "WAR" "El nombre $GRUPO$UINPUT se encuentra reservado"
	  				VALID="N"
	 	 			break
				fi
		    done
      		## If name not reserved
     		if [ $VALID == "Y" ]; then
        		echo "$GRUPO$UINPUT"
      		fi
    	else
      		VALID="Y"
      		echo "$2"
    	fi
  	done
}

continuar() {

    printf "Desea continuar con la instalacion? (S - N) "
    read input

    if [ "$input" == "S" ]; then
        salir=1;
    elif [ "$input" == "N" ]; then
        salir=0;
    else
        echo "Respuesta inválida."
        continuar
    fi
    Loguear "INF" "Desea continuar con la instalacion? (S - N) $input"

}

seteoVariables() {
	#notAllow = "dirconf"
	let salir=0
	while [ $salir -ne 1 ];
	do
		echo "Seteo de variables globales"
		Loguear "INF" "Seteo de variables globales"

		echo "Ingrese un nuevo valor (en caso de carpetas, solo el nombre de la misma) o solo ENTER para mantener el valor por defecto."
		Loguear "INF" "Ingrese un nuevo valor (en caso de carpetas, solo el nombre de la misma) o solo ENTER para mantener el valor por defecto."
		echo

 		## Request exec directory
 		DIRBIN=$(request_dirpath "Defina el directorio de Ejecutables ($DIRBIN): " $DIRBIN)
		## Request file directory
		DIRMAE=$(request_dirpath "Defina el directorio de Maestros y Tablas ($DIRMAE): " $DIRMAE)
 		## Request updates directory
		DIRNOV=$(request_dirpath "Defina el directorio de Recepcion de Novedades ($DIRNOV): " $DIRNOV)
 		## Request accepted files directory
 		DIROK=$(request_dirpath "Defina el directorio de Archivos Aceptados ($DIROK): " $DIROK)
		## Request processed files directory
		DIRVAL=$(request_dirpath "Defina el directorio de Archivos Validados ($DIRVAL): " $DIRVAL)
		## Request reports directory
		DIRREP=$(request_dirpath "Defina el directorio de Reportes ($DIRREP): " $DIRREP)
		## Request log directory
		DIRLOG=$(request_dirpath "Defina el directorio de Log ($DIRLOG): " $DIRLOG)
		## Request rejected directory
		DIRNOK=$(request_dirpath "Defina el directorio de Rechazados ($DIRNOK): " $DIRNOK)

		clear
		echo "DETALLE DE LA CONFIGURACIÓN:"
		Loguear "INF" "DETALLE DE LA CONFIGURACIÓN:"
		echo
		echo "Directorio de Configuracion: $CONFDIR"
		Loguear "INF" "Directorio de Configuracion: $CONFDIR"
		echo "Directorio de Ejecutables: $DIRBIN"
		Loguear "INF" "Directorio de Ejecutables: $CONFDIR"
		echo "Directorio de Maestros: $DIRMAE"
 		Loguear "INF" "Directorio de Ejecutables: $CONFDIR"
		echo "Directorio de Recepcion de Novedades: $DIRNOV"
		Loguear "INF" "Directorio de Recepcion de Novedades: $CONFDIR"
		echo "Directorio de Archivos Aceptados: $DIROK"
		Loguear "INF" "Directorio de Archivos Aceptados: $CONFDIR"
		echo "Directorio de Archivos Rechazados: $DIRNOK"
		Loguear "INF" "Directorio de Archivos Rechazados: $CONFDIR"
		echo "Directorio de Archivos de Reportes: $DIRREP"
		Loguear "INF" "Directorio de Archivos de Reportes: $CONFDIR"
		echo "Directorio de Archivos Validados: $DIRVAL"
		Loguear "INF" "Directorio de Archivos Validados: $CONFDIR"
		echo "Directorio de Archivos de Log: $DIRLOG"
		Loguear "INF" "Directorio de Archivos de Log: $CONFDIR"


		continuar
	done
}


generarArchConfiguracion(){

	echo "Creando archivo de configuración en $CONFDIR$ARCH_CNF..."
	Loguear "INF" "Creando archivo de configuración en $CONFDIR$ARCH_CNF..."
	fecha_y_hora=$(date "+%d/%m/%Y %H:%M:%S")

	echo "Actualizando la configuracion del sistema"
	Loguear "INF" "Actualizando la configuracion del sistema"

	echo "GRUPO=${GRUPO%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRLOG=${DIRLOG%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRBIN=${DIRBIN%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRMAE=${DIRMAE%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRNOV=${DIRNOV%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIROK=${DIROK%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRREP=${DIRREP%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRVAL=${DIRVAL%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"
	echo "DIRNOK=${DIRNOK%?}=$USER=$fecha_y_hora" >> "$CONFDIR""$ARCH_CNF"

}

###########################################################################################################
################################################ REGION: PROGRAMA #########################################
###########################################################################################################
echo "Chequeando instalacion previa"
Loguear "INF" "Chequeando instalacion previa"
# Chequea instalacion previa
if [ -e "$CONFDIR""$ARCH_CNF" ]
  then
  	if [ $# -ne 1 ]
	then 
 		echo "Parametro incorrecto."
		Loguear "ERR" "Parametro incorrecto."
		exit 1
	fi
 	if [ $1 != "-i" -a $1 != "-t" ]
 	then 
  		echo "Parametro incorrecto."
		Loguear "ERR" "Parametro incorrecto."
		exit 1
	fi
  	while read linea
	do
		nombre=$(echo $linea | cut -f1 -d '=')
		valor=$(echo $linea | cut -f2 -d '=')
		declare $nombre=$valor 
	done < "$CONFDIR$ARCH_CNF"

	echo "Ya existe una instalación previa."
	Loguear "WAR" "Ya existe una instalación previa."
	echo "Directorio de Configuracion: $CONFDIR"
	Loguear "INF" "Directorio de Configuracion: $CONFDIR"
	echo "Directorio de Ejecutables: $DIRBIN"
	Loguear "INF" "Directorio de Ejecutables: $DIRBIN"
	echo "Directorio de Maestros: $DIRMAE"
	Loguear "INF" "Directorio de Maestros: $DIRMAE"
	echo "Directorio de Recepcion de Novedades: $DIRNOV"
	Loguear "INF" "Directorio de Recepcion de Novedades: $DIRNOV"
	echo "Directorio de Archivos Aceptados: $DIROK"
	Loguear "INF" "Directorio de Archivos Aceptados: $DIROK"
	echo "Directorio de Archivos de Reportes: $DIRREP"
	Loguear "INF" "Directorio de Archivos de Reportes: $DIRREP"
	echo "Directorio de Archivos de Log: $DIRLOG"
	Loguear "INF" "Directorio de Archivos de Log: $DIRLOG"
	echo "Directorio de Archivos Validados: $DIRVAL"
	Loguear "INF" "Directorio de Archivos Validados: $DIRVAL"
	echo "Directorio de Archivos Rechazados: $DIRNOK"
	Loguear "INF" "Directorio de Archivos Rechazados: $DIRNOK"
	if [ $1 = "-i" ]; then reinstalar; exit 0
	elif [ $1 = "-t" ]; then exit 0; fi
fi

if [ $# -ne 1 ]
	then 
 	echo "Parametro incorrecto."
	Loguear "ERR" "Parametro incorrecto."
	exit 1
fi
if [ $1 != "-i" -a $1 != "-t" ]
then 
 	echo "Parametro incorrecto."
	Loguear "ERR" "Parametro incorrecto."
	exit 1
fi

if [ $1 == "-t" ]
  then 
	echo "No existe una instalación previa."
	Loguear "INF" "No existe una instalación previa."
	exit 0
fi

echo
echo "~ Inicio de instalación del sistema ~"
Loguear "INF" "Inicio de instalación del sistema"
echo "-------------------------------------------"
echo
chequeoVersionPerl
seteoVariables
echo
echo "-------------------------------------------"
echo
echo "Creando estructuras de directorio..."
Loguear "INF" "Creando estructuras de directorio..."
echo

# CREACIÓN DE DIRECTORIOS


mkdir --parents -m 777 "$DIRBIN" "$DIRMAE" "$DIRNOV" "$DIROK" "$DIRNOK" "$DIRVAL" "$DIRREP" "$DIRLOG" "$CONFDIR"

mv ./datos/*.csv $DIRMAE
rm -rf ./datos

generarArchConfiguracion
mv ./*.sh $DIRBIN
cp $DIRBIN/Instalador.sh $GRUPO

echo
echo "Instalacion CONCLUIDA"
Loguear "INF" "Instalacion CONCLUIDA"
echo


echo "Fin de la instalación"
Loguear "INF" "Fin de la instalación"

mv $ARCH_LOG $CONFDIR
exit 0

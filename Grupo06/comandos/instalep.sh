#!/bin/bash

###########################################################################################################
################################################ REGION: VARIABLES ########################################
###########################################################################################################

GRUPO=$(pwd)"/Grupo06/"
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
	if [ ! -d $DIRBIN ]
	  then
		echo "Directorio de Configuracion: $DIRBIN"
		Loguear "INF" "Directorio de Configuracion: $DIRBIN"
		mkdir --parents "$DIRBIN"
	  else
		echo "Directorio de Configuracion: $DIRBIN ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIRBIN ya existe"
	fi
	if [ ! -d $DIRNOV ]
	  then
		echo "Directorio de Configuracion: $DIRNOV"
		Loguear "INF" "Directorio de Configuracion: $DIRNOV"
		mkdir --parents "$DIRNOV"
	  else
		echo "Directorio de Configuracion: $DIRNOV ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIRNOV ya existe"
	fi
	if [ ! -d $DIROK ]
	  then
		echo "Directorio de Configuracion: $DIROK"
		Loguear "INF" "Directorio de Configuracion: $DIROK"
		mkdir --parents "$DIROK"
	  else
		echo "Directorio de Configuracion: $DIROK ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIROK ya existe"
	fi
	if [ ! -d $DIRNOK ]
	  then
		echo "Directorio de Configuracion: $DIRNOK"
		Loguear "INF" "Directorio de Configuracion: $DIRNOK"
		mkdir --parents "$DIRNOK"
	  else
		echo "Directorio de Configuracion: $DIRNOK ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIRNOK ya existe"
	fi
	if [ ! -d $DIRVAL ]
	  then
		echo "Directorio de Configuracion: $DIRVAL"
		Loguear "INF" "Directorio de Configuracion: $DIRVAL"
		mkdir --parents "$DIRVAL"
	  else
		echo "Directorio de Configuracion: $DIRVAL ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIRVAL ya existe"
	fi
	if [ ! -d $DIRREP ]
	  then
		echo "Directorio de Configuracion: $DIRREP"
		Loguear "INF" "Directorio de Configuracion: $DIRREP"
		mkdir --parents "$DIRREP"
	  else
		echo "Directorio de Configuracion: $DIRREP ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIRREP ya existe"
	fi
	if [ ! -d $DIRLOG ]
	  then
		echo "Directorio de Configuracion: $DIRLOG"
		Loguear "INF" "Directorio de Configuracion: $DIRLOG"
		mkdir --parents "$DIRLOG"
	  else
		echo "Directorio de Configuracion: $DIRLOG ya existe"
		Loguear "INF" "Directorio de Configuracion: $DIRLOG ya existe"
	fi
	
}

chequeoVersionPerl(){
	echo "Chequeo de la version de Perl"
	Loguear "INF" "Chequeo de la version de Perl."
	
	if [ [ perl -v | grep -o -m 1 '[0-9]'| head -1 ] -lt 5 ]
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
	    Loguear "INF" "$1 $UINPUT"
	    ## Validate user input
	    if [ ! -z "$UINPUT" -a "$UINPUT" != " " ]; then
    	 	VALID="Y"
     		for rname in $RESERVED; do
				if [ $UINPUT == $rname ]; then
	  				echo -e "\n# El nombre $UINPUT se encuentra reservado\n" >&2
	  				Loguear "WAR" "El nombre $UINPUT se encuentra reservado"
	  				VALID="N"
	 	 			break
				fi
		    done
      		## If name not reserved
     		if [ $VALID == "Y" ]; then
        		echo "$UINPUT"
      		fi
    	else
      		VALID="Y"
      		echo "$2"
    	fi
  	done
}

seteoVariables() {
	#notAllow = "dirconf"

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
	DIRNOV=$(request_dirpath "Defina el directorio de Recepcion de Novedades ($DIRNOV): " $DIRREC)
 	## Request accepted files directory
 	DIROK=$(request_dirpath "Defina el directorio de Archivos Aceptados ($DIROK): " $DIROK)
	## Request processed files directory
	DIRVAL=$(request_dirpath "Defina el directorio de Archivos Validados ($DIRVAL): " $DIRVAL)
	## Request reports directory
	DIRREP=$(request_dirpath "Defina el directorio de Reportes ($DIRREP): " $DIRREP)
	## Request log directory
	DIRLOG=$(request_dirpath "Defina el directorio de log ($DIRLOG): " $DIRLOG)
	## Request rejected directory
	DIRNOK=$(request_dirpath "Defina el directorio de rechazados ($DIRNOK): " $DIRNOK)

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

	printf "Desea continuar con la instalacion? (S - N) "
	read input
	Loguear "INF" "Desea continuar con la instalacion? (S - N) $input"
	if [ "$input" != "S" ]; then 
		echo "Fin de la instalación"; 
		Loguear "INF" "Fin de la instalación"
		exit 1; 
	fi
}


generarArchConfiguracion(){
	ARCH_CNF="$CONFDIR""Instalep.conf"
	echo "Creando archivo de configuración en $ARCH_CNF..."
	Loguear "INF" "Creando archivo de configuración en $ARCH_CNF..."
	fecha_y_hora=$(date "+%d/%m/%Y %H:%M:%S")

	echo "Actualizando la configuracion del sistema"
	Loguear "INF" "Actualizando la configuracion del sistema"

	echo "DIRLOG=${DIRLOG%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "GRUPO=${GRUPO=$USER%?}=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIRBIN=${DIRBIN%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIRMAE=${DIRMAE%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIRNOV=${DIRNOV%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIROK=${DIROK%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIRREP=${DIRREP%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIRVAL=${DIRVAL%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
	echo "DIRNOK=${DIRNOK%?}=$USER=$fecha_y_hora" >> "$ARCH_CNF"
}

###########################################################################################################
################################################ REGION: PROGRAMA #########################################
###########################################################################################################

echo "Chequeando instalacion previa"
Loguear "INF" "Chequeando instalacion previa"
> Instalador.log
# Chequea instalacion previa
if [ -e "$CONFDIR""$ARCH_CNF" ]
  then
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
	if [ $1 = "-i" ]; then reinstalar; exit 0; fi
	if [ $1 = "-t" ]; then exit 0; fi
fi

if [ $1 = "-t" ]
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

mkdir --parents "$DIRBIN" "$DIRMAE" "$DIRNOV" "$DIROK" "$DIRNOK" "$DIRVAL" "$DIRREP" "$DIRLOG" "$CONFDIR"

generarArchConfiguracion

echo
echo "Instalacion CONCLUIDA"
Loguear "INF" "Instalacion CONCLUIDA"
echo


echo "Fin de la instalación"
Loguear "INF" "Fin de la instalación"

mv $ARCH_LOG $CONFDIR

cd "$DIRBIN"

exit 0

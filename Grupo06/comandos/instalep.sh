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


seteoVariables() {
	#notAllow = "dirconf"

	echo "Seteo de variables globales"
	Loguear "INF" "Seteo de variables globales"

	echo "Ingrese un nuevo valor (en caso de carpetas, solo el nombre de la misma) o solo ENTER para mantener el valor por defecto."
	Loguear "INF" "Ingrese un nuevo valor (en caso de carpetas, solo el nombre de la misma) o solo ENTER para mantener el valor por defecto."
	echo

	dirSinBarra="${DIRBIN%/*}"
	while
		printf "Defina el directorio de Ejecutables (default: ${dirSinBarra##*/}/): "		
		read input
		Loguear "INF" "Defina el directorio de Ejecutables (default: ${dirSinBarra##*/}/): " "$input"

		if [ "$input" != "" ]; then DIRBIN="$GRUPO""${input%/*}/"; else DIRBIN="$GRUPO""bin/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done

	dirSinBarra="${DIRMAE%/*}"
	while
		printf "Defina el directorio de Archivos Maestros (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Archivos Maestros (default: ${dirSinBarra##*/}/): " "$input"

		if [ "$input" != "" ]; then DIRMAE="$GRUPO""${input%/*}/"; else DIRME="$GRUPO""mae/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done

	dirSinBarra="${DIRNOV%/*}"
	while
		printf "Defina el directorio de Recepcion de Novedades (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Recepcion de Novedades (default: ${dirSinBarra##*/}/): " "$input"

		if [ "$input" != "" ]; then DIRNOV="$GRUPO""${input%/*}/"; else DIRNOV="$GRUPO""nov/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done
	
	dirSinBarra="${DIROK%/*}"
	while
		printf "Defina el directorio de Archivos Aceptados (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Archivos Aceptados (default: ${dirSinBarra##*/}/): " "$input"

		if [ "$input" != "" ]; then DIROK="$GRUPO""${input%/*}/"; else DIROK="$GRUPO""ok/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done
	
	dirSinBarra="${DIRNOK%/*}"
	while
		printf "Defina el directorio de Archivos Rechazados (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Archivos Rechazados (default: ${dirSinBarra##*/}/): " "$input"	

		if [ "$input" != "" ]; then DIRNOK="$GRUPO""${input%/*}/"; else DIRNOK="$GRUPO""nok/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done
	
	dirSinBarra="${DIRREP%/*}"
	while
		printf "Defina el directorio de Reportes (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Reportes (default: ${dirSinBarra##*/}/): " "$input"	

		if [ "$input" != "" ]; then DIRREP="$GRUPO""${input%/*}/"; else DIRREP="$GRUPO""rep/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done

	dirSinBarra="${DIRVAL%/*}"
	while
		printf "Defina el directorio de Archivos Validados (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Archivos Validados (default: ${dirSinBarra##*/}/): " "$input"

		if [ "$input" != "" ]; then DIRVAL="$GRUPO""${input%/*}/"; else DIRVAL="$GRUPO""listos/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done

	dirSinBarra="${DIRLOG%/*}"
	while
		printf "Defina el directorio de Logs (default: ${dirSinBarra##*/}/): "
		read input
		Loguear "INF" "Defina el directorio de Logs (default: ${dirSinBarra##*/}/): " "$input"

		if [ "$input" != "" ]; then DIRLOG="$GRUPO""${input%/*}/"; else DIRLOG="$GRUPO""log/"; fi
		if [ "$input" = "dirconf" ]; then 
			echo "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."
			Loguear "WAR" "El nombre $input se encuentra reservado. Por favor ingrese otro nombre."; fi
		[ "$input" = "dirconf" ]
	do :; done
	
	
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

echo "Inicio de la instalación"
Loguear "INF" "Inicio de la instalación"

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
	echo "Fin del proceso."
	Loguear "INF" "Fin del proceso."
fi



echo
echo "~ Inicio de instalación del sistema ~"
Loguear "INF" "Inicio de instalación del sistema"
echo "-------------------------------------------"
echo
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

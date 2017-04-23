#!/bin/bash
source logep.sh
source getCodAct.sh
source getNomCentro.sh
source getNomProv.sh
source getCodProv.sh

echo "Iniciando"
RUTA_ACTUAL=$PWD
while [[ $PWD != '/' && ${PWD##*/} != 'Grupo10' ]]
do
	cd ..
done

ARCH_CONF="$PWD/dirconf/Instalep.conf"
cd $RUTA_ACTUAL

if [ ! -e "$ARCH_CONF" ]
then
	echo "No existe el archivo de configuracion."
	echo "Presione ENTER para salir."
	read INPUT
	exit 0
fi


#Verifico si el ambiente ya ha sido inicializado
#if [[ ${INITREADY+x} ]]
#then
#	MENSAJE="Ambiente ya inicializado, para reiniciar termine la sesion e ingrese nuevamente"
#	echo $MENSAJE
#	Logep Procep "$MENSAJE" WAR
#	echo "Presione ENTER para salir."
#	read INPUT
#	exit 0
#fi

echo "Cargando configuracion"
while read variable; do 
	
	IFS='=' read -a variablesConf <<< "$variable"

	if [ "${variablesConf[0]}" == "DIRLOG" ]; then DIRLOG=( "${variablesConf[1]}" ); fi
	if [ "${variablesConf[0]}" == "DIRBIN" ]; then DIRBIN=( "${variablesConf[1]}" ); fi
	if [ "${variablesConf[0]}" == "DIRMAE" ]; then DIRMAE=( "${variablesConf[1]}" ); fi
	if [ "${variablesConf[0]}" == "DIRREC" ]; then DIRREC=( "${variablesConf[1]}" ); fi
	if [ "${variablesConf[0]}" == "DIROK" ]; then DIROK=( "${variablesConf[1]}" ); fi
	if [ "${variablesConf[0]}" == "DIRPROC" ]; then DIRPROC=( "${variablesConf[1]}" ); fi
	if [ "${variablesConf[0]}" == "DIRNOK" ]; then DIRNOK=( "${variablesConf[1]}" ); fi	

done < $ARCH_CONF

export LOGSIZE=1024

A_PROCESAR=$(ls $DIROK | wc -l )
MENSAJE="Cantidad de archivos a procesar: $A_PROCESAR"

Logep Procep "$MENSAJE" WAR

echo "Leyendo archivos a procesar"

CANTIDAD_PROCESADOS=0

ARCHIVOS=$(ls $DIROK ) #| grep -v '^([A-Za-z 0-9]*)_([0-9,]*)_([0-9,]*)_([0-9,]*).csv$')

for archivo in $ARCHIVOS
do
echo "Procesando archivo: $archivo"
file=$DIROK/$archivo
#Verifico duplicado
if [ -f $DIRPROC/$(basename $file) ];
then
	MENSAJE="Archivo Duplicado. Se rechaza el archivo $(basename $file)"

	if [ ! -d $DIRNOK ]; then mkdir $DIRNOK; fi
	#cp $file $DIRNOK/$(basename $file)	
	perl movep.pl $file $DIRNOK
 	Logep Procep "$MENSAJE" WAR
else

	REGEX='^([0-9]*);([0-9]*);([0-9.\-]*);([A-Za-z 0-9]*);([A-Za-z 0-9]*);([0-9,]*)$'
	continuar=true
{
read
	while read line && [[ $continuar == true ]]; do 
		
		if [[ ! $line =~ $REGEX ]];
		then
			MENSAJE="Estructura inesperada. Se rechaza el archivo $(basename $file)."

			if [ ! -d $DIRNOK ]; then mkdir $DIRNOK; fi

			perl movep.pl $file $DIRNOK

			continuar=false

			Logep Procep "$MENSAJE" WAR
		else
			MENSAJE="Archivo a procesar $(basename $file)."

			Logep Procep "$MENSAJE" INFO

			anio_presupuesto=$(echo $(basename $file) | cut -d'_' -f 2)
		
			centro=$(echo $line | cut -d';' -f 3)
			nombreCentro=$(getNomCentro "$centro" $DIRMAE)			

			actividad=$(echo $line | cut -d';' -f 4)
			codActividad=$(getCodAct "$actividad" $DIRMAE)

			codProv=$(getCodProv $(basename $file))
			nombreProvincia=$(getNomProv "$codProv" $DIRMAE)
			
			trimestre=$(echo $line | cut -d';' -f 5)

			gasto=$(echo $line | cut -d';' -f 6)              

			es_valido=true
			
			
			echo "Actividad : $actividad - Codigo actividad: $codActividad"

			registros_ok=0
			registros_rechazados=0
			
			MENSAJE_RECHAZO="Rechazo - "
			
			if [ -z "$nombreCentro" ]; then #! grep -q "$centro" $DIRMAE/centros.csv; then
				es_valido=false;
				MENSAJE_RECHAZO="$MENSAJE_RECHAZO Centro inválido"
			else

				if [ -z "$codActividad" ]; then #! grep -q "$actividad" $DIRMAE/actividades.csv; then
					es_valido=false;
					MENSAJE_RECHAZO="$MENSAJE_RECHAZO Actividad inválida"
				else
					if [ ! $gasto > 0 ]; then 
						es_valido=false; 
						MENSAJE_RECHAZO="$MENSAJE_RECHAZO Gasto inválido"
					else
						if ! grep -q "$trimestre" $DIRMAE/trimestres.csv; then
							es_valido=false; 
							MENSAJE_RECHAZO="$MENSAJE_RECHAZO Trimestre inválido"
						else
							echo "$line;$(basename $file);$codActividad;$nombreProvincia;$nombreCentro" >> $DIRPROC/ejecutado-$anio_presupuesto

							registros_ok=$((registros_ok+1))
						
							Logep Procep "Registros validados correctamente: $registros_ok." INFO
						fi 
						
					fi 
				fi 
			fi

			if ! $es_valido; then 

				echo "$MENSAJE_RECHAZO - $line" >> $DIRPROC/rechazado-$anio_presupuesto
				echo "Rechazado"
				registros_rechazados=$((registros_rechazados+1))
				
				Logep Procep "Registros rechazados: $registros_rechazados." INFO

			fi 
			
		fi			

	done
} < $file	

	if [ ! -d $DIRPROC ]; then mkdir $DIRPROC; fi
		
	if [ -f $file ]; then perl movep.pl $file $DIRPROC/proc; fi
	
fi

CANTIDAD_PROCESADOS=$((CANTIDAD_PROCESADOS+1))

done

echo "Cantidad de archivos procesados: $CANTIDAD_PROCESADOS."
Logep Procep "Cantidad de archivos procesados: $CANTIDAD_PROCESADOS." INFO



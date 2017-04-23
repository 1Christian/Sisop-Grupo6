#!/bin/bash

source logep.sh
source val_nom.sh
source val_prov.sh
source val_fecha.sh

export LOGSIZE="1024"

#configuro rutas
RUTA_ACTUAL=$PWD
while [[ $PWD != '/' && ${PWD##*/} != 'Grupo10' ]]
do
  cd ..
done
GRUPO=$PWD
ARCH_CONF="$PWD/dirconf/Instalep.conf"
cd $RUTA_ACTUAL

if [ ! -e "$ARCH_CONF" ]
then
  echo "No existe el archivo de configuracion."
  echo "Presione ENTER para salir."
  read INPUT
  exit 0
fi

#Si el ambiente no fue inicializado, no ejecutar
#mostrar msj

#DIRECTORIOS
#GRUPO
while read variable; do 

	IFS='=' read -a variablesConf <<< "$variable"
	if [ "${variablesConf[0]}" == 'DIRLOG' ]; then DIRLOG="${variablesConf[1]}"; fi
	if [ "${variablesConf[0]}" == "DIRBIN" ]; then DIRBIN="${variablesConf[1]}"; fi
	if [ "${variablesConf[0]}" == "DIRMAE" ]; then DIRMAE="${variablesConf[1]}"; fi
	if [ "${variablesConf[0]}" == "DIRREC" ]; then DIRREC="${variablesConf[1]}"; fi
	if [ "${variablesConf[0]}" == "DIROK" ]; then DIROK="${variablesConf[1]}"; fi
	if [ "${variablesConf[0]}" == "DIRPROC" ]; then DIRPROC="${variablesConf[1]}"; fi
	if [ "${variablesConf[0]}" == "DIRNOK" ]; then DIRNOK="${variablesConf[1]}"; fi	

done < $ARCH_CONF	

ciclo=1
while [ true ]
do
	MENSAJE="Demonep ciclo nro. $ciclo"
	echo $MENSAJE
	Logep Demonep "$MENSAJE" INFO

	#chequear si hay archivos en $GRUPO/DIRREC
	#LOG -> Archivo detectado: <nombre archivo>
	if [ "$(ls -A $DIRREC)" ]
	then
		cd $DIRREC
		for i in *
		do
      MENSAJE="Archivo detectado: $i"
			echo $MENSAJE
			Logep Demonep "$MENSAJE" INFO
			IFS='_' read -r -a array <<< "$i"
		  NAME=${array[3]%.*}
		  EXTENSION=${array[3]##*.}
		  date "+%Y%m%d" -d "$NAME" > /dev/null 2>&1
		  DATE=$?			
			TYPE=$(file $i | cut -d' ' -f2)
			RECH=0			

			#verificar que sea un archivo de texto
			if [ ! "$TYPE" == "ASCII" ] && [ ! "$TYPE" == "empty" ]
			then
				MENSAJE="Archivo rechazado, motivo: no es un archivo de texto"
				echo $MENSAJE
				Logep Demonep "$MENSAJE" WAR
				let RECH=1
			#verificar que no este vacio
			elif [ "$TYPE" == "empty" ]
			then
				MENSAJE="Archivo rechazado, motivo: archivo vacio"
				echo $MENSAJE
				Logep Demonep "$MENSAJE" WAR
				let RECH=1
			#verificar formato de nombre
			elif [ $(val_nom "$i") -eq 0 ]
			then
				MENSAJE="Archivo rechazado, motivo: nombre invalido"
				echo $MENSAJE
				Logep Demonep "$MENSAJE" WAR
				let RECH=1
			#verificar año
			elif [ ${array[1]} != $(date "+%Y") ]
			then
				MENSAJE="Archivo rechazado, motivo: año ${array[1]} incorrecto"
				echo $MENSAJE
				Logep Demonep "$MENSAJE" WAR
				let RECH=1
			#verificar provincia
			elif [ $(val_prov "${array[2]}" $DIRMAE) -eq 0 ]
			then
				MENSAJE="Archivo rechazado, motivo: provincia ${array[2]} incorrecta"
				echo $MENSAJE
				Logep Demonep "$MENSAJE" WAR
				let RECH=1
			#verificar fecha
			elif [ $(val_fecha $NAME) -eq 0 ]
			then
				MENSAJE="Archivo rechazado, motivo: fecha $NAME incorrecta"
				echo $MENSAJE
				Logep Demonep "$MENSAJE" WAR
				let RECH=1
			fi
            
      #aceptar o rechazar archivo
      if [ $RECH -eq 0 ]
      then
     	  MENSAJE="Archivo aceptado"
        echo $MENSAJE
        Logep Demonep "$MENSAJE" INFO
				perl $GRUPO/bin/movep.pl "$i" "$DIROK/" Demonep
      else
        MENSAJE="Archivo rechazado"
        #echo $MENSAJE
        Logep Demonep "$MENSAJE" INFO
				perl $GRUPO/bin/movep.pl "$i" "$DIRNOK/" Demonep
      fi
		done
	fi

	#Si existen archivos en DIROK y procep no esta corriendo
	cd $RUTA_ACTUAL
	if [ "$(ls -A $DIROK)" ]
	then
		#echo "detecto cosas en dirok"
		ps -a | grep -v grep | grep procep.sh > /dev/null
		result=$?
		if [[ "${result}" -ne "0" ]]
		then
			./procep.sh&
			ID=$!
			MENSAJE="Procep corriendo bajo el no.: $ID"
			echo $MENSAJE
			Logep Demonep "$MENSAJE" INFO
		else
			MENSAJE="Invocacion de procep pospuesta para el siguiente ciclo"
			echo $MENSAJE
			Logep Demonep "$MENSAJE" INFO
		fi
	fi

	sleep 5s
	((ciclo++))
done
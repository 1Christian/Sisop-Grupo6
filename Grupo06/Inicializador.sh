#!/bin/bash

Loguear() {
	WHEN=$(date "+%Y%m%d %H:%M:%S")
	echo "$WHEN-$USER-$WHERE-$1-$2" >> "$ARCH_LOG"  
}


verificarPermisos() {

	if [ ! -f "$1" ]
	then
		return
	fi

	if [[ "$1" == *.log && ! -w "$1" ]]
	then
		echo "Otorgado permiso de escritura a $1"
		Loguear "INF" "Otorgado permiso de escritura a $1"		
		chmod +w $1
	fi

	if [[ "$1" == *.sh && ! -x "$1" ]]
	then
		echo "Otorgado permiso de ejecución a $1"
		Loguear "INF" "Otorgado permiso de ejecución a $1"		
		chmod +x $1
	fi

	if [ ! -r "$1" ]
	then
		echo "Otorgado permiso de lectura a $1"	
		Loguear "INF" "Otorgado permiso de lectura a $1"	
		chmod +r $1
	fi

}

verificarDemonio() {
    MENSAJE="¿Desea efectuar la activación del Demonio? S - N"
    echo $MENSAJE
    read INPUT

    Loguear "INF" "$MENSAJE: $INPUT"

    if [ "$INPUT" == "S" ]
    then
        cd bin
    	./Start.sh Demonio.sh Inicializador
    	ID=$!
      	if [ $? == 0 ];
            then
        	  pid=$(pgrep -x -n "Demonio.sh" )
      	  Loguear "INF" "Demonio corriendo bajo el no.: $pid"
      	  echo $MENSAJE
    	  echo "Para detenerlo ingrese kill $pid"
    	  Loguear "INF" "Para detenerlo ingrese kill $pid"
        else
       	  Loguear "WAR" "No se ejecuto el dummy porque ya esta corriendo"
        fi
        cd ..
    elif [ "$INPUT" == "N" ]
        then
        echo "Para iniciar Demonio manualmente en background ingrese al directorio bin y ejecute ./Start.sh Demonio.sh"
        Loguear "INF" "Para iniciar Demonio manualmente en background ingrese al directorio bin y ejecute ./Start.sh Demonio.sh"
    else
        echo "Respuesta inválida"
        verificarDemonio
    fi
}

#cd ..
GRUPO=$(pwd)
ARCH_CONF="$GRUPO/dirconf/Instalador.conf"

#Seteo de variables de ambiente

while read linea
do
	nombre=$(echo $linea | cut -f1 -d '=')
	valor=$(echo $linea | cut -f2 -d '=')

	declare $nombre=$valor
	export $nombre="${valor}"

done < "$ARCH_CONF"

export PATH="${GRUPO}:${GRUPO}/bin/:${PATH}"

ARCH_LOG="$DIRLOG/Inicializador.Log"
chmod +w $ARCH_LOG
WHERE="Inicializador"

Loguear "INF" "Se han seteado correctamente las siguientes variables: "
Loguear "INF" "PATH=$PATH"
Loguear "INF" "GRUPO=$GRUPO"
Loguear "INF" "DIRBIN=$DIRBIN"
Loguear "INF" "DIRMAE=$DIRMAE"
Loguear "INF" "DIRLOG=$DIRLOG"
Loguear "INF" "DIRNOK=$DIRNOK"
Loguear "INF" "DIRNOV=$DIRNOV"
Loguear "INF" "DIRVAL=$DIRVAL"
Loguear "INF" "DIROK=$DIROK"
Loguear "INF" "DIRREP=$DIRREP"

if [ ! -e "$ARCH_CONF" ]
then
	echo "No existe el archivo de configuracion."
	Loguear "ERR" "No existe el archivo de configuracion."
	echo "Presione ENTER para salir."
	read INPUT
	Loguear "INF" "Presione ENTER para salir: $INPUT"
	exit 0
fi


#Verifico si el ambiente ya ha sido inicializado

if [[ ${INITREADY+x} ]]
then
	MENSAJE="Ambiente ya inicializado, para reiniciar termine la sesion e ingrese nuevamente"
	echo $MENSAJE
	Loguear "ERR" "$MENSAJE"
	echo "Presione ENTER para salir."
	read INPUT
	Loguear "INF" "Presione ENTER para salir: $INPUT"
	exit 0
fi


MENSAJE="Estado del Sistema: INICIALIZADO"
echo $MENSAJE
Loguear "INF" "$MENSAJE"

#Verificacion de permisos
find $GRUPO -type f | while read archivo
do
	verificarPermisos $archivo
done
Loguear "INF" "Permisos seteados correctamente."


#Arranque del demonio
verificarDemonio
export INITREADY=1

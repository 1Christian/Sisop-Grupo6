#!/bin/bash
#Devuelve 1 si hay error, de lo contrario, devuelve 0

CmdInvoc=""
Loguear() {
	WHEN=$(date "+%Y%m%d %H:%M:%S")
	echo "$WHEN-$USER-$3-$1-$2" >> "$DIRLOG/$3.log"
}

if [ $# -lt 2 -o $# -gt 3 ]; then
	
echo "Numero de parametros equivocado"
	exit 1

else

	Arch=${1##*/} # dejo solo lo que este despues de la ultima /
	Orig=${1%/*} # dejo lo que este antes de la ultima /
	Dest=$2

	if [ $# -eq 3 ]; then
		CmdInvoc=$3
	fi

	if [ "$Orig" == "$Dest" ]; then

		if [ ! $CmdInvoc = "" ]; then
			Loguear "ERR" "Se ha producido un error al intentar mover el archivo" $CmdInvoc
		fi
		exit 1

	elif [ ! -d "$Orig" -o ! -d "$Dest" ]; then

		if [ ! $CmdInvoc = "" ]; then
			Loguear "ERR" "Se ha producido un error al intentar mover el archivo" $CmdInvoc
		fi
		exit 1

	elif [ -f "$Dest/$Arch" ]; then

		if [ ! -d "$Dest/dpl" ]; then
			mkdir "$Dest/dpl"
		fi
		Contador=1
		while [ -a "$Dest/dpl/$Arch.$Contador" ]; do
			Contador=$[$Contador+1]
		done

		if [ ! $CmdInvoc = "" ]; then
			Loguear "ERR" "Se ha producido un error al intentar mover el archivo" $CmdInvoc
		fi

		cp "$Orig/$Arch" "$Dest/dpl/$Arch.$Contador"
		 	Loguear "INF" "Se ha movido el archivo" $CmdInvoc
		rm "$Orig/$Arch"
		exit 0

	else
		mv "$Orig/$Arch" "$Dest/$Arch"
		exit 0
	fi

fi



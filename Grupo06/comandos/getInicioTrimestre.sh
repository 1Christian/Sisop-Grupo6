#!/bin/bash
function getInicioTrimestre {
	trimestre=$1
	RUTA=$2
	IFS=$';'
	fechaDesde=""
	while read col1 col2 col3 col4
	do
		if [ "$col2" == "$trimestre" ]
		then
			fechaDesde="$col3"
		fi
	done < "$RUTA/trimestres.csv"
	echo $fechaDesde
}


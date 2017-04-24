#!/bin/bash
function getFinTrimestre {
	trimestre=$1
	RUTA=$2
	IFS=$';'
	fechaFin=""
	while read col1 col2 col3 col4
	do
		if [ "$col2" == "$trimestre" ]
		then
			fechaFin="$col4"
		fi
	done < "$RUTA/trimestres.csv"
	echo $fechaFin
}


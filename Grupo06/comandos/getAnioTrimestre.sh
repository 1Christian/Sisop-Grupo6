#!/bin/bash
function getAnioTrimestre {
	trimestre=$1
	RUTA=$2
	IFS=$';'
	anioTrimestre=0
	while read col1 col2 col3 col4
	do
		if [ "$col2" == "$trimestre" ]
		then
			let anioTrimestre=$col1
		fi
	done < "$RUTA/trimestres.csv"
	echo $anioTrimestre
}


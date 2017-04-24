#!/bin/bash
function getCodAct {
	nombreActividad=$1
	RUTA=$2
	IFS=$';'
	codigoActividad=""
	while read col1 col2 col3 col4
	do
		if [ "$col4" == "$nombreActividad" ]
		then
			codigoActividad="$col1"
		fi
	done < "$RUTA/actividades.csv"
	echo $codigoActividad
}


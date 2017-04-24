#!/bin/bash
function getNomCentro {
	codigoCentro=$1
	RUTA=$2
	IFS=$';'
	nombreCentro=""
	while read columna1 columna2
	do
		if [ "$columna1" == "$codigoCentro" ]
		then
			nombreCentro="$columna2"
		fi
	done < "$RUTA/centros.csv"
	echo $nombreCentro
}


#!/bin/bash
function getNomProv {
	codigoProvincia=$1
	RUTA=$2
	IFS=$';'
	nombreProvincia=0
	while read col1 col2 col3
	do
		if [ "$col1" == "$codigoProvincia" ]
		then
			nombreProvincia="$col2"
		fi
	done < "$RUTA/provincias.csv"
	echo $nombreProvincia
}


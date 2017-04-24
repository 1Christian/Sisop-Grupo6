#!/bin/bash
function getCodProv {
	nombreArchivo=$1
	IFS=_ read -ra arr <<<"$nombreArchivo"
        provincia=( "${arr[2]}" );
	echo $provincia
}


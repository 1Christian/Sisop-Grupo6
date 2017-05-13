#!/bin/bash
########## Script para detener cualquier proceso de tipo demonio ##########
########## Ejemplo de uso: ./Stop proceso         ##########

if [ $# != 1 ];
then
  echo "Stop: Cantidad de parametros distinto a uno"
  exit 1
fi

pids=$(pgrep -x "$1")

if [ "$pids" != "" ];
then
  kill $pids
  echo "Se detuvo con exito el proceso $1"
else
  echo "El proceso $1 no se encuentra en ejecucion"
fi

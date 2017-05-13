#!/bin/bash
########## Script para iniciar cualquier proceso  ##########
########## Ejemplo de uso: ./Start proceso        ##########
if [ $# == 2 ];
then
	ARCH_LOG="$DIRLOG/$2.log"
else
	ARCH=$(echo "$1" | cut -d "." -f1)
	ARCH_LOG="$DIRLOG/$ARCH.log"
fi
function Loguear() {
  WHEN=$(date "+%Y%m%d %H:%M:%S")
  WHERE="Start"
  echo "$WHEN-$USER-$WHERE-$1-$2" >> "$ARCH_LOG"  
}


if [ $# -gt 2 ];
then
  echo "Stop: Cantidad de parametros distinto a uno"
  exit 2
fi

pids=$(pgrep -x "$1")

if [ "$pids" != "" ];
then
  echo "Ejecucion cancelada, el proceso $1 ya se encuentra en ejecucion"
	Loguear "WAR" "Ejecucion cancelada, el proceso $1 ya se encuentra en ejecucion"
  exit 1
else
  echo "Ejectuando proceso $1 "
  bash -c "./$1&"
  pids=$(pgrep -x "$1")
  Loguear "INF" "Proceso $1 ejecutado en ejecucion"
  Loguear "INF" "PID:$pids"
  exit 0
fi

#!/bin/bash
GRUPO="/home/nacho/Escritorio/Grupo06"
DIRLOG=$GRUPO"/log"
ARCH_LOG=$DIRLOG"/dummy.log"
WHEN=$(date "+%Y%m%d %H:%M:%S")
echo "$WHEN-$USER-dummy-INF-Se ejecuto el dummy" >> "$ARCH_LOG"
while ( true );
do
	((i++))
done
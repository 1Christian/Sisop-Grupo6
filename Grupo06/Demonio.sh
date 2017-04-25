#!/bin/bash
############Inicializacion la utilizo para probar, cuando se integre quitar################
GRUPO="/home/nacho/Escritorio/Grupo06"
DIRBIN=$GRUPO"/bin"
DIRMAE=$GRUPO"/mae"
DIRNOV=$GRUPO"/nov"
DIROK=$GRUPO"/ok"
DIRNOK=$GRUPO"/nok"
DIRVAL=$GRUPO"/listos"
DIRREP=$GRUPO"/rep"
DIRLOG=$GRUPO"/log"
#LOGEP=$DIRBIN"/Logep"
#PROCEP=$DIRBIN"/Procep"
MOVEP=$DIRBIN"/Mover"
############################################################################################
BANCOS=$DIRMAE"/bamae.csv"
ARCH_LOG=$DIRLOG"/demonio.log"

variables_ambiente=(GRUPO DIRBIN DIRMAE DIRNOV DIROK DIRVAL DIRLOG DIRREP)
directorios_necesarios=(DIRMAE DIRNOV DIROK DIRNOK DIRLOG DIRBIN)
directorios_lectura=(DIRMAE DIRNOV)
directorios_escritura=(DIROK DIRNOK DIRLOG)
directorios_ejecucion=(DIRBIN)
archivos_necesarios=(DUMMY MOVER BANCOS)
archivos_ejecucion=(DUMMY MOVER)
sleep_segs=5
comando="Demonep"

function Loguear() {
  WHEN=$(date "+%Y%m%d %H:%M:%S")
  WHERE="Demonep"
  echo "$WHEN-$USER-$WHERE-$1-$2" >> "$ARCH_LOG"  
}

function verificar_variables_ambiente(){
  for elem in "${variables_ambiente[@]}"
  do
    if [ -z ${!elem} ]; then      
      echo "ERROR: No existe la variable de ambiente: \"${elem}\"."
      exit 1;
    fi  
  done
}

function verificar_existencia_directorios(){
  for elem in "${directorios_necesarios[@]}"
  do
    if [ ! -d ${!elem} ]; then      
      echo "ERROR: No existe el directorio: \"${!elem}\"."
      exit 2;
    fi  
  done
}

function verificar_directorios_lectura(){
  for elem in "${directorios_lectura[@]}"
  do
    if [ ! -r ${!elem} ]; then      
      echo "ERROR: No existen permisos de lectura en directorio: \"${!elem}\"."
      exit 3;
    fi  
  done
}

function verificar_directorios_escritura(){
  for elem in "${directorios_escritura[@]}"
  do
    if [ ! -w ${!elem} ]; then      
      echo "ERROR: No existen permisos de escritura en directorio: \"${!elem}\"."
      exit 4;
    fi  
  done
}

function verificar_directorios_ejecucion(){
  for elem in "${directorios_ejecucion[@]}"
  do
    if [ ! -x ${!elem} ]; then      
      echo "ERROR: No existen permisos de ejecucion en directorio: \"${!elem}\"."
      exit 5;
    fi  
  done
}

function verificar_existencia_archivos(){
  for elem in "${archivos_necesarios[@]}"
  do
    if [ ! -e ${!elem} ]; then      
      echo "ERROR: No existe el archivo: \"${!elem}\"."
      exit 6;
    fi  
  done
}

function verificar_archivos_lectura(){
  for elem in "${archivos_lectura[@]}"
  do
    if [ ! -r ${!elem} ]; then      
      echo "ERROR: No se cuentan con permisos de lectura para el archivo: \"${!elem}\"."
      exit 7;
    fi  
  done
}

function verificar_archivos_ejecucion(){
  for elem in "${archivos_ejecucion[@]}"
  do
    if [ ! -x ${!elem} ]; then      
      echo "ERROR: No se cuentan con permisos de ejecucion para el archivo: \"${!elem}\"."
      exit 8;
    fi  
  done
}

function verificar_ambiente(){
  verificar_variables_ambiente
  verificar_existencia_directorios
  verificar_directorios_lectura
  verificar_directorios_escritura
  verificar_directorios_ejecucion
  verificar_existencia_archivos
  verificar_archivos_lectura
  verificar_archivos_ejecucion
}

function archivo_texto(){
  if [[ $(file --mime-type "${1}" | grep -c "t*xt" -) > 0 ]];
  then
    return 1
  fi
  return 0
}

function archivo_vacio(){
  if [ ! -s "$1" ]
  then
    return 1
  fi
  return 0
}

function archivo_formato_erroneo(){
  if [[ $(echo "$1" | grep -c '.*_[0-9]\{8\}.csv$') != 1 ]];
  then
    return 1
  fi
  return 0
}

function banco(){
  echo "$1" | cut -d'_' -f 1
}

function fecha(){
  echo "$1" | cut -d '_' -f 2 | cut -d '.' -f 1 
}

function banco_valido(){
  for elem in `cat $BANCOS|cut -d ';' -f 1`; do
    if [ $1 == $elem ];
    then
      return 1
    fi
  done
  return 0
}

function es_fecha(){
  fecha=$1
  mes=${fecha:4:2}
  dia=${fecha:6:2}
  case $mes in
  01|03|05|07|08|10|12)
      cant_dias=31
      if [ $dia -gt $cant_dias -o $dia -lt 1 ]; then
  return 0
      fi
    ;;
  04|06|09|11)
      cant_dias=30
      if [ $dia -gt $cant_dias -o $dia -lt 1 ]; then
  return 0
      fi
    ;;
  02)
      cant_dias=28
      if [ $dia -gt $cant_dias -o $dia -lt 1 ]; then
  return 0
      fi
    ;;    
  *) return 0
   ;;
  esac
  return 1
}

function get_dias_mes(){
  mes=$1
  case $mes in
  01|03|05|07|08|10|12)
      return 31
    ;;
  04|06|09|11)
      return 30
    ;;
  02)
       return 28
    ;;    
  *) return 0
   ;;
  esac
  return 0
}

function fecha_valida(){
  let fecha_ahora=$(date +%Y%m%d);
  let fecha_arch=$1
  let dia_hoy=$(date +%d)
  let dia_arch=${fecha_arch:6:2}
  let mes_hoy=$(date +%m)
  let mes_arch=${fecha_arch:4:2}
  let diferencia_dias=$dia_hoy-$dia_arch
  let diferencia_meses=$mes_hoy-$mes_arch
  let cumple=0

  if [ $mes_arch == $mes_hoy -a $diferencia_dias -le 15 -a $diferencia_dias -ge 0 ];
  then
    cumple=1
  elif [ $diferencia_meses -le 1 ];
  then
    let dias_mes_arch=get_dias_mes $mes_arch
    dia_arch=$dias_mes_arch-$dia_arch
    diferencia_dias=$dia_arch+$dia_hoy
    if [ $diferencia_dias -gt 15 ];
    then
      cumple=0
    else
      cumple=1
    fi
  fi
  es_fecha $fecha_arch

  if [ $? == 1 -a $fecha_ahora -ge $fecha_arch -a $cumple == 1 ]; then
    return 1
  fi
  return 0
}

function archivo_tipo_contenido_valido(){
  archivo=$1
  if [ "$archivo" != "" ]; 
  then
    #Punto 4 VERIFICAR QUE EL ARCHIVO SEA UN ARCHIVO COMÚN, DE TEXTO .
    archivo_texto $archivo
    if [ $? == 0 ]; 
    then
      Loguear "INF" "Archivo rechazado, motivo: no es un archivo de texto"
      return 0
    else
      # Punto 5 VERIFICAR QUE EL ARCHIVO NO ESTÉ VACIO.
      archivo_vacio $archivo
      if [ $? == 1 ];
      then
	Loguear "INF" "Archivo rechazado, motivo: archivo vacio"
	return 0
      else
	return 1
      fi
    fi
  fi    
}

function archivo_nombre_args_valido(){
  archivo=$1
  #Punto 6.VERIFICAR QUE EL FORMATO DEL NOMBRE DEL ARCHIVO SEA CORRECTO
  archivo_formato_erroneo $archivo
  if [ $? == 1 ];
  then
    Loguear "INF" "Archivo rechazado, motivo: formato de nombre incorrecto."
    return 0
  else
    #Punto 7.VERIFICAR BANCO
    banco_archivo=$(banco $archivo)
    banco_valido $banco_archivo
    if [ $? == 0 ];
    then
    	Loguear "INF" "Archivo rechazado, motivo: banco $banco_archivo incorrecto."
      return 0
    else
      #Punto 8.VERIFICAR FECHA
	    fecha_archivo=$(fecha $archivo)
	    fecha_valida $fecha_archivo
	    if [ $? == 0 ];
	    then
	      Loguear "INF" "Archivo rechazado, motivo: fecha $fecha_archivo incorrecta."
	      return 0
	    else
	      return 1
	    fi
    fi
  fi
}

function ver_dummy(){
  if [ "$(ls -A $DIROK)" ]; then
    if [[ $(pgrep -c "dummy") -gt 1 ]];
    then
      Loguear "INF" "Invocación de Dummy pospuesta para el siguiente ciclo"
    else
      Dummy
    fi;
  fi
}


function Dummy(){
  ubicacion=$PWD
  cd $DIRBIN
  ./dummy.sh&
  pid=$(pgrep -x -n "dummy" )
  Loguear "INF" "dummy corriendo bajo el no.: $pid"
  cd $ubicacion    
}

function mover(){
  ubicacion=$PWD
  cd $DIRBIN
  ./Mover.sh "$1" "$2" "demonio"
  cd $ubicacion
}

function main(){
  ubicacion=$PWD
  cd $GRUPO
  #Punto 1 OBLIGACIÓN DE INICIAR AMBIENTE ANTES DE EJECUTAR CUALQUIER COMANDO
  verificar_ambiente
  let contador_ciclos=1
  #Punto 2 MANTENER UN CONTADOR DE CICLOS DE EJECUCIÓN DE DEMONEP .
  while ( true );
  do
    Loguear "INF" "Demonep ciclo nro. $contador_ciclos"
    #Punto 3.CHEQUEAR SI HAY ARCHIVOS EN EL DIRECTORIO $GRUPO/DIRNOV
    cd $DIRNOV
    archivos_aceptados=0
    if [ "$(ls -A)" ]; then
      for archivo in *
      do
        Loguear "INF" "Archivo detectado: $archivo"
        archivo_tipo_contenido_valido $archivo
        if [ $? == 1 ];
        then
          archivo_nombre_args_valido $archivo
          if [ $? == 1 ];
          then
            #Punto 9.ACEPTAR LOS ARCHIVOS CON NOMBRE VÁLIDO.
            Loguear "INF" "Archivo aceptado"
            mover $DIRNOV/$archivo $DIROK
          else
            #Punto 10.RECHAZAR LOS ARCHIVOS INVÁLIDOS
            mover $DIRNOV/$archivo $DIRNOK
          fi
        else
          mover $DIRNOV/$archivo $DIRNOK
        fi
      done  
      ver_dummy
    fi
    ((contador_ciclos++))
    #Punto 13 DORMIR UN TIEMPO X Y EMPEZAR UN NUEVO CICLO
    sleep $sleep_segs;
    cd $ubicacion
  done
}

main

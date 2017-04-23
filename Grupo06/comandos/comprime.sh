cp codigo/instalep.sh ninstalep.sh

COMANDO_CODIGO='s,codigo/,source/DIRBIN/,'
COMANDO_DOCS='s,docs/,,'
COMANDO_INSTALEPN='s,^ninstalep.sh$,instalep.sh,'
COMANDO_DIRMAE='s,DIRMAE/,source/DIRMAE/,'
COMANDO_COMPLETO='flags=r;'"$COMANDO_CODIGO"';'"$COMANDO_DOCS"';'"$COMANDO_INSTALEPN"';'"$COMANDO_DIRMAE"

tar --transform="$COMANDO_COMPLETO" --show-transformed -cvzf entregar/source.tar.gz codigo/* DIRMAE/* docs/Readme.md docs/Informe.docx ninstalep.sh

rm ninstalep.sh

echo "Si me llamas con c te lo instalo tambien, NO LLAMO INITEP"
if [ "$#" -ge 1 ] && [ "$1" == "c" ]
then
	echo "Instalando"
	rm -rf instalacion
	mkdir instalacion
	cp entregar/source.tar.gz instalacion/source.tar.gz
	tar -xzf instalacion/source.tar.gz --directory instalacion
	cd instalacion
	. instalep.sh
	cd Grupo10/bin
	. initep.sh
#	echo "\
#\
#\
#\
#\
#\
#\
#\
#\
#Si\
#Si\
#\
#" | ./instalep.sh
fi

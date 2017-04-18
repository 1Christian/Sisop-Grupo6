#!/bin/perl
use File::Basename;

($origen, $destino, $invoc) = @ARGV;

#Subrutina para mover archivos duplicados
sub mover_duplicado{
	my ($or, $name, $des) = @_;
	print "Numero $or en $des \n";
	if (opendir (DIRH,$des)){
		@flist=readdir (DIRH);
		closedir (DIRH);
	}
	$max = 0;
	foreach(@flist){
		next if ($_ eq "." || $_ eq "..");
		my ($ndes, $path, $suffix) = fileparse($_,qr/\.[^.]*/);
		if ($ndes eq $name){
			print "Archivo:$_ Duplicado\n";
			$suffix =~ s/.//;
			if ($suffix gt $max){
				$max = $suffix;
			}
		}
	}
	$max++;
	$new_name = $name . "." . $max;
	$new_dest = $des . $new_name;
	#print "New: $new_name\n";
	rename ($or, $new_dest);
}

#Le doy formato a destino
@d = split("/",$destino);
$destino = join('/',@d);
$destino = $destino . "/";

my ($name, $path, $suffix) = fileparse($origen,qr/\.[^.]*/);
print "Nombre: $name, Path: $path, Sufijo: $suffix, Destino: $destino\n";

#Si no existe origen
if (!-e $origen){
#log del error
	print "No existe origen\n";
	exit;
}

#Si no existe destino
if (!-e $destino){
	#log del error
	print "No existe destino\n";
	exit;
}

#Si destino y origen son iguales
if ($path eq $destino){
	#log del error
	print "Origen y destino son iguales!\n";
	exit;
}

#Si el origen es Carpeta
if (!-f $origen){
	print "Origen no es un archivo\n";
	exit;
}

#Si destino es Archivo
if (-f $destino){
	print "Destino es un archivo\n";
	exit;
}

#Leo el contenido de destino
if (opendir (DIRH,$destino)){
	@flist=readdir (DIRH);
	closedir (DIRH);
}

#Evaluo si el archivo ya existe en el destino
$dup = 0; #Si el archivo ya existe en el destino
foreach(@flist){
	next if ($_ eq "." || $_ eq "..");
	if ($_ eq $name){
		print "Archivo ya existe\n";
		$error = 1;
		$dup = 1;
		#creo carpeta dpl si no existe
		if (! (-e $destino . "/dpl")){
			mkdir $destino."/dpl";
		}
		last;
	}
}

if ($dup){
	#archivo duplicado
	$new_dest = $destino . "dpl/";
	if (-e $new_dest . $name){
		#indicar en hipotesis la cantidad de numeros para numerar.
		print "New_dest: $new_dest\n";
		&mover_duplicado($origen, $name, $new_dest);
	}else{
		system ("mv $origen $new_dest");
	}
}else{
	system ("mv $origen $destino");
}

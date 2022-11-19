# Elena Aguayo Jara
# Máster de Bioinformática y Biología Computacional - Universidad Autónoma de Madrid
# 20/11/2022


# !/bin/bash

# Declarar variables
DIR=$1
string=$2
file_out=$3

# Comprobar el número de parámetros de entrada
if [ ! $# -eq 3 ]
then
	echo -e "Número de parámetros de entrada incorrecto" >&2

	exit 138
else
	echo -e "Número de parámetros de entrada correcto"
fi



# Comprobar que no existe el fichero de salida ni los archivos temporales; si existen, se borran
if [ -f $3 ] && [ -f tmp1.txt ] && [ -f tmp2.txt ] && [ -f tmp3.txt ]
then 
	echo -e "Los archivos existen\n""Borrando archivos..."
	rm $3 tmp1.txt tmp2.txt tmp3.txt
fi


# Comprobar que el fichero de salida tiene permiso de lectura; si no lo tiene, se cambia
if [ ! -r $3 ]
then 
	echo -e "El fichero $3 no tiene permiso de lectura\n""Otorgando permiso de lectura...\n""Permiso de lectura concedido"
	chmod u+r $3
fi



# Comprobar que existe el directorio
if [ ! -d $1 ] 
then
	echo -e "El directorio $1 no existe"	

# Si el directorio existe, realizar búsqueda de parámetros
else
	echo -e "\nEl directorio $1 existe\n""Creando archivo..."

	
# -type d busca directorios, grep -r realiza una búsqueda recursiva de los strings en subdirectorios, grep -c cuenta las ocurrencias, cut permite extraer los campos que  nos interesan
# egrep permite buscar varias palabras a la vez separadas por un pipe, sort -k2 ordena según el valor del segundo campo (en este caso es el número de ocurrencias)

	find $1 -type d | egrep -irwc $2 $1 | tr ":" "/" | sort -k2 | cut -d "/" -f6  > tmp1.txt
	find $1 -type d | egrep -irwc $2 $1 | cut -d ":" -f 1 | cut -d "/" -f 1-5 |  sort -k2 > tmp2.txt
	find $1 -type d | egrep -irwc $2 $1 | cut -d ":" -f 2 | sort -k2 > tmp3.txt
	
	# Juntamos en columnas los archivos temporales que redirigen su salida a $3
	paste tmp1.txt tmp2.txt tmp3.txt > $3

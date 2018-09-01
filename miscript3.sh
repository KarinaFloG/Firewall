#!/bin/bash


#Comandos a ejecutar si es la primera vez que usas el script, si no, comentalos con #.
#mkdir /media/usb #Para Debian
#mkdir /run/media/usb #Para Fedora
#touch lista_blanca | touch lista_negra
#####################################################################################
#Inicia programa:


#Primero se obtiene el número serial de la usb
numserial=$(dmesg | tail -n 15 | egrep Serial | awk '{print $6'} )
#Se desmonta la usb para evitar los riesgos
umount /dev/sdb1  

#echo "Introduce tu nombre se usuario"
#read user

#Aquí se analiza si existe el número serial está más de una vez en la lista negra, si es así, entonces no monta el dispositivo
if [ $( egrep --count $numserial lista_negra ) -ne 0 ] ;
then
echo "Tu usb no tiene permiso para ejecutarse"

#Analizamos si el número serial está más de una vez en la lista blanca, siendo este el caso, se monta en la carpeta usbs en media
elif [ $( egrep --count $numserial lista_blanca ) -ne 0 ] ;
then
echo "Tu usb está en la lista blanca"
echo "Se montará para usarse"
mount /dev/sdb1 /media/usb   #Para Debian
#mount /dev/sdb1 /media/$user # Para Fedora
#mount /dev/sdb1 /run/media/usb

else
#Si el número no existe entonces ejecuta los siguientes comandos
echo "Tu dispositivo no está en ninguna lista"
echo "¿Que quieres hacer?"
echo "1. Mandar a lista blanca"
echo "2. Mandar a lista negra"

read a
case $a in
(1)
echo "Elegiste mandar a la lista blanca"
echo "$numserial" >> lista_blanca
mount /dev/sdb1 /media/usb #Para debian
#mount /dev/sdb1 /media/$user # Para Fedora
#mount /dev/sdb1 /run/media/usb  
exit
;;
(2)
echo "Elegiste mandar a la lista negra"
echo "$numserial" >> lista_negra
exit
;;
(*)
exit
;;
esac
fi


hdparm -Y /dev/sdb



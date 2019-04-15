#!/bin/bash

#Formato de log
#dd/mm/YYYY-hh:mm:ss-Comentario.

function sele_fecha {
while true ; do
clear
echo "            dd/mm/YYYY"
read -p "$1" fech
if ( echo $fech | egrep -xq [0-2][0-9]"/"[0-1][0-9]"/"[0-1][0-9]{3} || echo $fech | egrep -xq 3[0-1]"/"[0-1][0-9]"/"[0-1][0-9]{3} ) ; then
 if ( echo $fech | egrep -xq 3[0-1]"/02/"[0-1][0-9]{3} ) ; then
  echo "Febrero puede tener hasta 29 dias"
  sleep 2
  break
 fi 
else
echo "Escribio mal la fecha"
sleep 2
fi
done
}

#function incrementar_fecha {
 
#       ano=`echo $fcom | cut -f 3 -d "/"`
#       mes=`echo $fcom | cut -f 2 -d "/"`
#       dia=`echo $fcom | cut -f 1 -d "/"`
#       dia=$((dia+1))
#      if [ $dia -ge 31 ] ; then
#         mes=$((mes+1))
#        dia=01
#     fi
#     if [[ $mes -eq 2 ]] && [[ $dia -gt 29 ]] ; then
#         mes=$((mes+1)
#         dia=01
#	if [ $mes -ge 12 ] ; then
#	  ano=$((ano+1))
#  	  mes=01
#          dia=01
#        fi
#       fcom="$dia/$mes/$ano"
#       fi
#}

. Ver_root.sh
while true ; do
clear
echo -e "\t\t\tREGISTROS\n1-Ver todo el registro\n2-Buscar registro durante periodo del dia3-Ver registro de dia especifico"
echo -e "4-Ver registro entre fecha especifica\n5-Salir\n"
read -p "Opcion: " op
case "$op" in


1) 
clear
echo "Para salir recuerde presionar Q"
sleep 2 
cat log_sigen.txt | more
;;

2) 
while true ; do
 clear
 read -p "Desde:" hs1
 read -p "Hasta:" hs2
 if [ $hs1 -le $hs2 ] ; then
  break
 else
 echo "La hora de finalizado no puede ser menor a la de comienzo" 
fi
done
sele_fecha "De la fecha: "
echo "Recuerde para salir presionar Q"
sleep 2
while [ $hs1 -le $hs2 ] ; do
 cat log_sigen.txt | egrep -wq $fech-$hs1
 hs1=$((hs1+1))
done  
;;

3) 
clear
sele_fecha "Ingrese fecha: "
cat log_sigen.txt | egrep -wq $fech | more
;;

4) 
clear
sele_fecha "Fecha de comienzo: "
fcm=$fech
sele_fecha "Fecha de finalizacion :"
ffin=$fech
echo "Recuerde presionar Q para salir"
sleep 2
echo "" >temp.txt
if ( `echo $fcom | cut -f 3 -d "/"` -eq `echo $ffin | cut -f 3 -d "/"` ) ; then
  if ( `echo $fcom | cut -f 2 -d "/"` -eq `echo $ffin | cut -f 2 -d "/"` ) ; then
    if ( `echo $fcom | cut -f 1 -d "/"` -eq `echo $ffin | cut -f 1 -d "/"` ) ; then
     cat log_sigen.txt | egrep -w $fcom | more #Misma fecha
    elif ( `echo $fcom | cut -f 1 -d "/"` -lt `echo $ffin | cut -f 1 -d "/"` ) ; then
      while `echo $fcom | cut -f 1 -d "/"` -lt `echo $ffin | cut -f 1 -d "/"` ; do
       cat log_sigen.txt | egrep -w $fcom >>temp.txt 
 #      incrementar_fecha 
      done
       less temp.txt #Mismo año, mismo mes
    else
    echo "El dia de comienzo es mayor al de finalizacion"
    sleep 2   
    fi
  elif ( `echo $fcom | cut -f 2 -d "/"` -lt `echo $ffin | cut -f 2 -d "/"` )
    while `echo $fcom | cut -f 2 -d "/"` -lt `echo $ffin | cut -f 2 -d "/"` ; do
       cat log_sigen.txt | egrep -w $fcom >>temp.txt
      #  incrementar_fecha
      done
     less temp.txt
    else
    echo "El mes de comienzo es mayor al de finalizacion"
   sleep 2
   fi
  elif ( `echo $fcom | cut -f 3 -d "/"` -lt `echo $ffin | cut -f 3 -d "/"` ) ; then
   while `echo $fcom | cut -f 3 -d "/"` -lt `echo $ffin | cut -f 3 -d "/"` ; do
    cat log_sigen.txt | egrep -w $fcom >>temp.txt
   #  incrementar_fecha
     done
    less temp.txt
   else 
     echo "El año de comienzo no puede ser mayor al de finalizacion"
   fi
;;
5) 
break
;;
*) 
echo "Ingrese opcion valida"
;;
esac
done 

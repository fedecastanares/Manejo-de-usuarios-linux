#!/bin/bash

#Formato de log
#dd/mm/YYYY-hh:mm:ss-Comentario.

function incrementar_hora {
hora=`echo $hr1 | cut -f 1 -d ":"`
min=`echo $hr1 | cut -f 2 -d ":"`
if [ $min -ge 59 ] ; then
 if [ $hora -ge 23 ] ; then
  hora=0
  else
  hora=$((hora+1))
 fi
 min=0
else
 min=$((min+1))
fi
hr1="$hora:$min"
}




function sele_fecha {
while true ; do
clear
echo "    dd/mm/YYYY    ej: 28/02/1992"
read -p "$1" fech
if ( echo $fech | egrep -xq [0-2][0-9]"/"[0-1][0-9]"/"[0-2][0-9]{3} || echo $fech | egrep -xq 3[0-1]"/"[0-1][0-9]"/"[0-2][0-9]{3} ) ; then
 if ( echo $fech | egrep -xq 3[0-1]"/02/"[0-2][0-9]{3} ) ; then
  clear
  echo "Febrero puede tener hasta 29 dias"
  sleep 2
else
  echo "Fecha correcta"
  sleep 2
  break
 fi 
else
echo "Escribio mal la fecha"
sleep 2
fi
done
}

function sele_hora {
while true ; do
clear
echo "    hh:mm    ej: 09:42"
read -p "$1" hr
if ( echo "$hr" | egrep -xq [0-2][0-9]":"[0-5][0-9]  &&  echo "$hr" | egrep -xq "2"[0-3]:[0-5][0-9] ) ; then
echo "hora correcta"
sleep 2
break
else
echo "hora incorrecta"
sleep 2
fi
done
}

while true ; do
clear
rm -f temp.txt
echo -e "\t Registro:"
echo -e "1-Completo\n2-De un dia\n3-De una hora\n4-De las horas\n5-Salir"
read -p "Opcion:" op
case $op in

1)
clear
echo "Recuerde presionar Q para salir"
sleep 2
less log_sigen.txt 
;;

2) 
clear
sele_fecha "Ingrese fecha: "
clear
echo "Recuerde presionar Q para salir"
sleep 2
cat log_sigen.txt | egrep $fech >> temp.txt
less temp.txt
;;

3)
clear
sele_fecha "Ingrese fecha: "
sele_hora "Ingrese hora: "
cat log_sigen.txt | egrep "$fech-$hr" >> temp.txt
less temp.txt
;;

4)
clear
sele_fecha "Ingrese fecha: "
sele_hora "Ingrese hora de comienzo: "
hr1=$hr
sele_hora "Ingrese hora de finalizacion: "
hr2=$hr
while [ $hr1 != $hr2 ] ; do
if [ $hora -lt 10 -a $min -lt 10 ] ; then
 cat log_sigen.txt | egrep "$fech-0$hora:0$min" >>temp.txt
elif [ $hora -lt 10 -a $min -ge 10 ] ; then
 cat log_sigen.txt | egrep "$fech-0$hora:$min" >>temp.txt
elif [ $hora -ge 10 -a $min -lt 10 ] ; then
 cat log_sigen.txt | egrep "$fech-$hora:0$min" >>temp.txt
else
cat log_sigen.txt | egrep "$fech-$hr1" >>temp.txt
fi
incrementar_hora
done
cat log_sigen.txt | egrep "$fech-$hr2" >>temp.txt
less temp.txt
;;

5)
break
;;


esac
done

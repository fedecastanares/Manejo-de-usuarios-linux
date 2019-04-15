#!/bin/bash


#Formato del comentario en pwd
#Nombre-Apellido-CI

. Ver_root.sh
while true ; do
clear
echo -e "\t\t. SCRIPT DE AGREGADO DE USUARIOS POR LISTA\n"
echo -e "\t\t1-Agregar usuarios mediante lista\n\t\t0-Salir"
read -p "Opcion:" op
case $op in
1)
while true ; do
 clear
 echo "Ingrese el nombre de documento de texto (.txt) que contenga el listado:"
 ls  *.txt
 read -p "Documento: " doc
 if [ -f "$doc" ] ; then
  echo "Usuarios creados:"
  i=`wc -l $doc | cut -f 1 -d " "`
  c=1
  while [ "$c" -le "$i" ] ; do
   ver_ci=`cat "$doc" | cut -f3 -d "-" | sed -n "$c"p`    
   letrausu=`cat "$doc" | cut -c1 | sed -n "$c"p`
   apellido=`cat "$doc" | cut -f2 -d "-" | sed -n "$c"p | tr -d " "`
echo "$apellido"
    if ( cat /etc/passwd | cut -f 3 -d "-" | egrep [0-9]{7} | cut -f 1 -d : | egrep -wq "$ver_ci" ) ; then
     echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Se quiso agregar un usuario con cedula :"$ver_ci" pero ya existia." >>log_sigen.txt
     echo "La cedula de `cat "$doc" | cut -f1 -d "-" | sed -n "$c"p` $apellido ya existe"
     sleep 1 	
    else
     num=1
     login=""$letrausu""$apellido""
     usu="$login"
     if ( cat /etc/passwd | cut -f 1 -d ":" | egrep -wq "$login" ) ; then
      while true ; do
	if ( cat /etc/passwd | cut -f 1 -d ":" | egrep -wq "$login$num" ) ; then
        num=$((num+1))
	else
	break
	fi
      done
      useradd -l ""$usu""$num"" -mk /etc/skel  -c `cat "$doc" | sed -n "$c"p | tr -d " "` -s /bin/bash 2>/dev/null
      #echo "$usu:$ver_ci" | chpasswd
      if [ $? -eq 0 ] ; then 
      echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Usuario: "$usu" creado exitosamente mediante lista. " >>log_sigen.txt
      echo "$usu$num"
      sleep 0.5
      fi
     else
      useradd -l "$usu" -mk /etc/skel  -c `cat "$doc" | sed -n "$c"p | tr -d " "` -s /bin/bash 2>/dev/null
      if [ $? -eq 0 ] ; then      
       #echo "$usu:$ver_ci" | chpasswd
      echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Usuario: "$usu$num" creado exitosamente mediante lista. " >>log_sigen.txt
      echo "$usu"
      sleep 0.5
      fi
     fi
    fi
    c=$((c+1))
   done
  fi
 break 
 done
sleep 2
;;
0) break
Script_usuarios.sh
;;
*) echo "Ingrese opcion valida"
sleep 2
esac
done


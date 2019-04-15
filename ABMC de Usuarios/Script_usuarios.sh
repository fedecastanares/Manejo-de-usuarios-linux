#!/bin/bash


function no_vac 
{	
			while true ; do
			read -p "$1" dato
			if [ -z "$dato" ] ; then 
				echo No es valido el ingreso de datos vacios
				sleep 1
				clear
			else
				if echo "$dato" | egrep -q "[^a-zA-Z][a-z A-Z]{15}"  ; then 
					echo "Debe contener debe contener solo letras o 1 espacio."
					sleep 1
					clear
				else
					echo -e "$2"
					sleep 2
					break	
					clear
				fi
			fi
			done
}

function ver_CI
{				
			clear
			while true ; do		
			read -p "Ingrese Cedula: " VCI
			if echo "$VCI" | egrep -wq "[0-9]{7}" ; then
				if (cat /etc/passwd | cut -f 3 -d "-" | egrep [0-9]{7} | cut -f 1 -d : | egrep -wq "$VCI") ; then
					echo "Cedula ya ingresada en el sistema"
					sleep 2
					clear
					return 1
				else				
					echo "Cedula correcta"
					sleep 2
					break
					clear
					return 0
				fi
			else
				echo "Formato invalido, pruebe solo numeros y sin el digito verificador"
				sleep 2
				clear			
			fi
			done
}

function usu_existe {
		while true ; do
		clear
		echo -e "\t\tLos Siguientes no estan disponibles:\n \n"
		cat /etc/passwd | cut -d : -f1 | more
		echo -e "\t \t \n"
		while true ; do
			read -p "Ingrese su nombre de usuario: " dato
			if [ -z "$dato" ] ; then 
				echo No es valido el ingreso de datos vacios
				sleep 1
				clear
			else
				if echo "$dato" | egrep -q [^a-zA-Z0-9]  ; then 
					echo "Debe contener solo letras o numeros."
					sleep 1
					clear
				else
					echo -e "Su nombre de usuario es correcto"
					break
					clear
				fi
			fi
			done
		if (cat /etc/passwd | egrep -wq "$dato") ; then
			echo "El usuario ya existe"
			sleep 2
			clear
		else 
			echo "El nombre de usuario: "$dato" se puede usar"
			sleep 2
			break
			clear
		fi		
		done	
}

function select_group {
		echo -e ""$1""
		cat /etc/group | egrep [0-9]{3} | cut -f1 -d : | more
		echo -e "\nUsuario: "$usu""		
		read  -p "Grupo: " GROUP 
		if [ -z "$GROUP" ] ; then
			echo No es valido que este vacio
			sleep 2
			clear
		else
			if (cat /etc/group | egrep -wq "$GROUP") ; then
				echo Seleccionado correctamente
				sleep 2
				clear
			else
				echo El grupo no existe
				sleep 2		
				clear
			fi
		fi
}

function agregar_a_grupo { 
			clear
			if [ "$1" = 1 ] ; then
			select_group "Seleccione el grupo en el que quiere pertenecer:\n"
			gpasswd -a "$usu" "$GROUP"
			echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Se agrego al grupo: "$GROUP" el usuario: "$usu"" >>log_sigen.txt
			elif [ "$1" = 2 ] ; then
			select_group "Seleccione el grupo en el que se quiere dar de baja:\n"
			gpasswd -d "$usu" "$GROUP"
			echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Se borro del grupo: "$GROUP" el usuario: "$usu"" >>log_sigen.txt
			else
			echo "Error"
			sleep 3		
			fi			
}

function alta_usuario {
				echo -e "\t\tDesea que el usuario:\n1 - Cree su propio grupo\n2 - Pertenezca a otro"		
				read -p "Opcion: " op
				case "$op" in
				1)clear
				useradd -l "$usu" -d /home/"$usu" -m -c ""$NOM"-"$APE"-"$VCIV"" -p "$contra" -s /bin/bash 2>/dev/null 
				if [ "$?" = 0 ] ; then 
					echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Usuario: "$usu" creado exitosamente." >>log_sigen.txt
					echo "`date +%d/%m/%Y` - `date +%H:%M:%S` - Usuario "$usu" creado exitosamente."
					sleep 2
					clear
				else
					echo "Ocurrio un error, si perciste el mismo contacte un administrador" 
					sleep 2
				fi	
				;;
				2) clear
				select_group 
				GROUPV=$GROUP
				useradd -l "$usu" -d /home/"$usu" -m -c ""$NOM" "$APE" "$VCIV"" -p "$contra" -g "$GROUPV" -s /bin/bash 2>/dev/null 
				if [ "$?" = 0 ] ; then 
					echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Usuario: "$usu" perteneciente al Grupo: "$GROUP" creado exitosamente" >>log_sigen.txt
					echo "`date +%d/%m/%Y` - `date +%H:%M:%S` - Usuario "$usu" creado exitosamente."
					sleep 2
					clear
				else
					echo Ocurrio un error, si perciste el mismo contacte un administrador 
					sleep 2
				fi
				;;
				*) clear
				echo "Ingrese opcion correcta"
				sleep 2
				;;
				esac
				while true ; do
				echo -e "Desea agregarle mas grupos al usuario?\n1- Si\n2- No"
				read -p "Opcion: " op
				case "$op" in
				1) clear 
				agregar_a_grupo 1
				echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-El usuario: "$usu" se ha agregado correctamente al grupo: "$GROUP"" >>log_sigen.txt
				echo "Se agrego el usuario "$usu" al gurpo "$GROUP""
				sleep 3
				clear
				;;
				2) clear 
				break
				;;
				*) clear
				echo "Ingrese opcion correcta"
				;;
				esac 	
				done
}

function baja_usuario {
			echo "Usuarios registrados: "
			cat /etc/passwd | cut -f 1,3 -d : | egrep [0-9]{4}
			echo -e "\n\n"
			read -p "Ingrese el ID del usuario que desea borrar: " IDUSU
			if [ -z "$IDUSU" ] ; then
				echo "No son validos los datos vacios."
				sleep 2
				clear
			else if ( echo "$IDUSU" | egrep -q [^1-9]{4}) ; then 
				echo "Una ID no tiene letras"
				sleep 2
				clear
			else
				if ( cat /etc/passwd | cut -f3 | egrep -wq "$IDUSU" ) ; then
					USU=`cat /etc/passwd | egrep "$IDUSU" | cut -f1 -d : `
					userdel -r "$USU" 2>/dev/null
					if [ $? -ne 0 ] ; then
						echo "Ocurrio algun error, si persiste consulte con un administrador"
						sleep 2
						clear
					else
						echo "Usuario eliminado exitosamente"
						echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Usuario "$usu" eliminado exitosamente. ">>log_sigen.txt
						sleep 2
						clear
					fi		
				else
					echo "No existe un usuario con esa ID"
					sleep 2
					clear
				fi
			fi
		fi
}

function modificar_usu {
			while true ; do
			clear
			echo "		Modificacion de usuarios"
			echo "1) Modificar nombre de usuario"
			echo "2) Modificar contraseña de usuario"
			echo "3) Agregar usuario a un grupo"
			echo "4) Borrar a un usuario de un grupo"
			echo "0) Volver"
			read -p "Opcion: " i
			case "$i" in
			1)
			clear
			modific_nom
			;;
			2)
			clear
			modificar_contra
			;;
			3) clear
			select_usuario
			agregar_a_grupo "1"
			sleep 3
			;;
			4) clear
			select_usuario
			agregar_a_grupo "2"
			sleep 3	
			;;
			0)
			break
			;;
			*)
			echo "Introdusca una opcion valida"
			;;
			esac
			done
			}
function modific_nom {
			while true ; do
			echo "Seleccione un nombre de usuario a modificar: "
			cat /etc/passwd | cut -f1 -d : | more
			read -p "Nombre a modificar: " usu
			if [ -z "$usu" ] ; then
				echo "No se ha ingresado nada"
				sleep 2
				clear
			else
				if ( cat /etc/passwd | egrep -wq "^"$usu"" ) ; then
				read -p  "Ingrese nuevo nombre: " nnom
				if [ -z "$nnom" ] ; then
					echo "No ha ingresado nada"
					sleep 2 
					clear
				else
					if ( cat /etc/passwd | egrep -wq "$nnom" ) ; then
					echo "Este nombre ya esta siendo usado"
					sleep 2
					clear
					else
					usermod -d /home/"$nnom" -m -l "$nnom" "$usu" 2>/dev/null
						if [ "$?" -ne 0 ] ; then
							echo "Ha ocurrido un error"
							sleep 2
							clear
						else
							echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Usuario "$usu" modifico su nombre a "$nnom".">>log_sigen.txt
							echo "Usuario modificado exitosamente."
							sleep 2
							break
							clear
						fi
					fi
				fi
			else
				echo "No existe el usuario en el sistema."
				sleep 2
				clear
			fi
		fi
		done
} 

function modificar_contra {
			echo "Seleccione un nombre de usuario a modificar: "
			cat /etc/passwd | cut -f1 -d : | more
			read -p "Nombre a modificar: " usu
			if [ -z "$usu" ] ; then
				echo "No se ha ingresado nada"
				sleep 2
				clear
			else
				if ( cat /etc/passwd | egrep -wq "^"$usu"" ) ; then
					while true ; do
					clear
					echo -n "Ingrese su contraseña: "
					read -s contra
					echo -ne "\nConfirme su contraseña:"
					read -s contra2
					if [ "$contra" = "$contra2" ] ; then
						echo -e "\nSe ha ingresado su contraseña correctamente"
						sleep 2
						break
					else
						echo -e "\nLas contraseñas no coiciden"
						sleep 2
					fi
					done
				usermod -p "$pass" "$usu" 2>/dev/null
					if [ "$?" -ne 0 ] ; then
						echo -e "\nHa ocurrido un error"
						sleep 2
						clear
						else
						echo  "`date +%d/%m%Y`-`date +%H:%M:%S`-Usuario "$usu" modifico su nombre a $nnom.">>log_sigen.txt
						echo -e "\nUsuario modificado exitosamente."
						sleep 2
						clear
						fi
			else
				echo "No existe el usuario en el sistema."
				sleep 2
				clear
			fi
		fi
}

function ver_usuarios {
		clear
		w=1
		echo -e "\t\tUsuarios existentes:\n"
		i=`cat /etc/passwd | cut -f 1,3 -d : | egrep -c [1-9][0-9]{3}`
		i=$((i+1))		
		sleep 1
		while [ "$w" -lt "$i" ] ; do
		echo -e "Usuario: `cat /etc/passwd | cut -f 1,3 -d : | egrep [0-9]{4} | cut -f 1 -d : | sed -n "$w"p`\t\tID: `cat /etc/passwd | cut -f 1,3 -d : | egrep [0-9]{4} | cut -f 2 -d : | sed -n "$w"p`"
		w=$((w+1))		
		done		
		echo -e "\n\n"
}

function select_usuario
			while true ; do
			echo "Seleccione un nombre de usuario a modificar: "
			cat /etc/passwd | cut -f1 -d : | more
			read -p "Nombre de usuario a modificar: " usu
			if [ -z "$usu" ] ; then
				echo "No se ha ingresado nada"
				sleep 2
				clear
			else
				if ( cat /etc/passwd | egrep -wq "^"$usu"" ) ; then
					echo "Usuario: "$usu""					
					break					
				fi
			fi
			clear
			done 

. Ver_root.sh
while true ; do
clear
echo " 							     "
echo "			 _____   _   _____   _____   __   _  "
echo "			/  ___/ | | /  ___| | ____| |  \ | | "
echo "			| |___  | | | |     | |__   |   \| | "
echo "			\___  \ | | | |  _  |  __|  | |\   | "
echo "			 ___| | | | | |_| | | |___  | | \  | "
echo "			/_____/ |_| \_____/ |_____| |_|  \_| "
echo "	 		     ___   _____       ___  ___  " 
echo "			    /   | |  _  \     /   |/   | "
echo "			   / /| | | |_| |    / /|   /| | "
echo "			  / / | | |  _  {   / / |__/ | | "
echo "			 / /  | | | |_| |  / /       | | "
echo "			/_/   |_| |_____/ /_/        |_| "
echo "	      _   _   _____   _   _       ___   _____    _   _____   _____  "
echo "	     | | | | /  ___/ | | | |     /   | |  _  \  | | /  _  \ /  ___/ "
echo "	     | | | | | |___  | | | |    / /| | | |_| |  | | | | | | | |___  "
echo "	     | | | | \___  \ | | | |   / / | | |  _  /  | | | | | | \___  \ "
echo " 	     | |_| |  ___| | | |_| |  / /  | | | | \ \  | | | |_| |  ___| | "
echo "	     \_____/ /_____/ \_____/ /_/   |_| |_|  \_\ |_| \_____/ /_____/ "
echo "


			      Opciones:
			1) Alta de usuarios
			2) Baja de usuarios
			3) Modificacion de usuarios
			4) Ver usuarios
			5) Agregar usuarios mediante lista
			0) Salir		     


											"
read -p "			Seleccione su opcion: " op			
case $op in
1) clear
no_vac "Ingrese su nombre: " "Su nombre ha sido aceptado"
NOM=$dato
clear
no_vac "Ingrese su apellido: " "Su apellido ha sido aceptado"
APE=$dato
clear
ver_CI
if [ "$?" = 0 ] ; then
VCIV=$VCI
clear
usu_existe
usu=$dato
while true ; do
	clear
	echo -n "Ingrese su contraseña: "
	read -s contra
	echo -ne "\nConfirme su contraseña:"
	read -s contra2
	if [ "$contra" = "$contra2" ] ; then
		echo -e "\nSe ha ingresado su contraseña correctamente"
		sleep 2
		break
	else
		echo -e "\nLas contraseñas no coiciden"
		sleep 2
	fi
done
clear
alta_usuario
fi
;;
2) clear
baja_usuario
;;
3)	
modificar_usu
;;
4) clear
ver_usuarios
read -sp "Pulse enter para salir"
;;
5). Script_listausu.sh
;;
0) clear
break
. Sistema.sh			
;;
*) echo "Ingrese opcion valida"
sleep 1
;;
esac
done

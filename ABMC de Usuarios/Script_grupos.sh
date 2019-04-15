#!/bin/bash



function alta_grupo {
		while true ; do
		clear
		echo -e "Grupos creados: \n\n"
		cat /etc/group | cut -f 1,3 -d : | egrep [0-9]{4} | cut -f1 -d :
		echo -e "\n\n"
		read -p  "Ingrese nombre del nuevo grupo: " NGRU
		if [ -z "$NGRU" ] ; then
			echo "No es valido el ingreso vacio de datos"
			sleep 2
			clear
		else
			if ( cat /etc/group | cut -f 1 -d : | egrep -wq "$NGRU" ) ; then
				echo "Ya existe el grupo"
				sleep 2
				clear
			else
				groupadd "$NGRU" 2>/dev/null
					if [ "$?" = 0 ] ; then
						echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Grupo "$NGRU" creado exitosamente.">>log_sigen.txt
						echo "Grupo "$NGRU" creado exitosamente."
						sleep 2
						break
						clear
					else
						echo "Ocurrio un error durante el proceso"
						sleep 2
						clear
					fi
				fi
			fi
			done
}

function baja_grupo {
		while true ; do
		clear
		echo -e "\tGrupos a eliminar: \n"
		cat /etc/group | cut -f1,3 -d : | egrep [0-9]{4} | cut -f1 -d :
		echo -e "\n"
		read -p "Ingrese nombre de grupo a borrar: " nmgroup
		if [ -z "$nmgroup" ] ; then
			echo "No se ha ingresado nada"
			sleep 2
			clear
		else
			if ( cat /etc/group | cut -f1 -d : | egrep -wq "$nmgroup" ) ; then 
				groupdel "$nmgroup" 2>/dev/null
			if [ "$?" = 0 ] ; then 
				echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-El grupo: "$nmgroup" ha sido borrado exitosamente." >>log_sigen.txt
				echo "`date +%d/%m/%Y` - `date +%H:%M:%S`  -  El grupo: "$nmgroup" ha sido borrado exitosamente." 
				sleep 2
				break
				clear
			else
				echo "Ha ocurrido un error" 
				sleep 2
				clear
			fi
		else
			echo "No hay grupo con ese nombre"
			sleep 2
			clear
			fi
		fi
		done
}

function mod_group {
		while true ; do
		echo -e "\t\t Modificacion de grupo: "
		echo "1)Modificar nombre de grupo"
		echo "2)Modificar ID del grupo"
		echo "0)Volver"
		read -p "Opcion: " OP
		clear
		case "$OP" in 
		1) Mod_nom
		break
		;;
		2) mod_ID
		break
		;;
		0) 
		break
		;;
		*) echo "Introdusca una opcion valida"
		sleep 2
		break
		clear
		;;
		esac
done
}

function Mod_nom { 
		while true ; do
		echo -e "Grupos: \n\n"
		cat /etc/group | cut -f 1,3 -d : | egrep [0-9]{4} | cut -f 1 -d :
		echo -e "\n"
		read -p "Nombre de grupo a modificar: " NOMV
		if [ -z "$NOMV" ] ; then
			 echo "No ha ingresado nada"
			 sleep 2
			 clear
		else
			if ( cat /etc/group | egrep -wq "$NOMV" ) ; then 
			read -p "Ingrese nuevo nombre: " NNOM
			clear
			if [ -z "$NNOM" ] ; then
				echo "No ha ingresado nada"
				sleep 2
				clear
			else
				if ( cat /etc/group | egrep -wq "$NNOM" ) ; then
					echo "Este nombre ya existe"
					sleep 2
					clear
				else
	   				groupmod -n "$NNOM" "$NOMV" 2>/dev/null
					if [ "$?" = 0 ] ; then
						clear
						echo "Se modifico el nombre del grupo "$NOMV" a "$NNOM" exitosamente."
						echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Grupo: "$NOMV" modifico su nombre a "$NNOM"." >>log_sigen.txt 	
						sleep 2
						break
						clear
					else
						echo "Ha ocurrido un error"	
						sleep 2
						clear
					fi
				fi
			fi
		else
			echo "No existe este grupo en el sistema"
			sleep 2
			clear
		fi
	fi
done
}

function mod_ID {
		while true ; do
		clear
		echo -e "\t\t\nGrupos: \n\n"
		cat /etc/group | cut -f1,3 -d : | egrep [0-9]{4} | cut -f1 -d :
		echo -e "\n\n"
		read -p "Ingrese nombre de grupo a modificar: " NOMV
		clear
		if [ -z "$NOMV" ] ; then
			echo "No ingreso ningun dato"
			sleep 2
			clear
		else
			if ( cat /etc/group | egrep -wq "$NOMV" ) ; then 
				echo -e "Una ID contiene 4 numeros mayores a 1000\n\nID actual: `cat /etc/group | egrep -w "$NOMV" | cut -f 3 -d : `" 
				read -p "Ingrese nuevo ID: " NID
				if [ -z "$NID" ] ; then
					echo "Ingrese algun dato"
				else
					if [ `echo "$NID" | egrep [1-9][0-9]{3}` ] ; then
						IDG=`cat /etc/group | egrep -w "$NOMV" | cut -f 3 -d :`
						echo "ID nuevo "$NID" || ID VIEJO "$IDG""
						groupmod -g "$NID" "$NOMV" 2>/dev/null
					if [ "$?" = 0 ] ; then
						echo "`date +%d/%m/%Y`-`date +%H:%M:%S`-Se modifico el ID del grupo "$NOMV" a "$NID" exitosamente.">>log_sigen.txt
						echo "Se modifico el ID del grupo "$NOMV" a "$NID" exitosamente."
						sleep 4
						break
						clear
					elif [ "$?" = 1 ] ; then
						echo "Este ID ya esta en uso"
						sleep 2
						clear
					else
						echo "Ha ocurrido un error"
						sleep 2
						clear
						fi				
				else	
					echo "Error en el ingreso del nuevo numero"	
				fi
			fi
		else 
			echo "Ese grupo no existe"
			sleep 2
		fi
	fi	
	done
}	
	
function ver_grupos {
		clear
		w=1
		echo -e "\t\tGrupos existentes:\n"
		i=`cat /etc/group | cut -f 1,3 -d : | egrep -c [1-9][0-9]{3}`
		i=$((i+1))		
		sleep 1
		while [ "$w" -lt "$i" ] ; do
		echo -e "Grupo: `cat /etc/group | cut -f 1,3 -d : | egrep [0-9]{4} | cut -f 1 -d : | sed -n "$w"p`\t\tID: `cat /etc/group | cut -f 1,3 -d : | egrep [0-9]{4} | cut -f 2 -d : | sed -n "$w"p`"
		w=$((w+1))		
		done		
		echo -e "\n\n"
}

		clear
		. Ver_root.sh
		cont=1
		while [ $cont = 1 ] ; do
		clear
		echo -e "\n\n"
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
		echo -e "\t\t _____   _____    _   _   _____   _____   _____  
\t\t/  ___| |  _  \  | | | | |  _  \ /  _  \ /  ___/ 
\t\t| |     | |_| |  | | | | | |_| | | | | | | |___  
\t\t| |  _  |  _  /  | | | | |  ___/ | | | | \___  \ 
\t\t| |_| | | | \ \  | |_| | | |     | |_| |  ___| | 
\t\t\_____/ |_|  \_\ \_____/ |_|     \_____/ /_____/  

			
				      Opciones:
				1) Alta de grupo
				2) Baja de grupo
				3) Modificacion de grupo
				4) Ver grupos		
				0) Salir		     
		

											"
		read -p "				Ingrese su opcion: " op
		case $op in
		1) clear
		alta_grupo
		;;
		2) clear
		baja_grupo
		;;
		3) clear
		mod_group
		;; 
		4) clear
		ver_grupos
		read -sp "Pulse enter para salir"
		;;
		0) cont=0
		. Sistema.sh
		;;
		*) echo "Seleccione una opcion valida"
		;;
		esac
		done

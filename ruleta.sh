#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
        echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
        tput cnorm && exit 1
}

# Ctrl+c
trap ctrl_c INT

function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour} ${yellowColour}$0${endColour}\n"
	echo -e "\t${yellowColour}-m)${endColour} ${grayColour}Dinero con el que se desea jugar${endColour}\n"
	echo -e "\t${yellowColour}-t)${endColour} ${grayColour}Tecnica con la que se desea jugar${endColour} ${purpleColour}(${endColour}${yellowColour}martingala${endColour}${purpleColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
	exit 1
}

function martingala(){
	tput civis
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con la tecnica${endColour}${yellowColour} $technique${endColour}\n"
	echo -e "${yellowColour}[+]${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour} $money€${endColour}\n"
	echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿Cuánto dinero tienes pensado apostar? --> ${endColour}${yellowColour}" && tput cnorm && read initial_bet && tput civis
	echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿A qué deseas apostar continuamente? (par/impar) --> ${endColour}${yellowColour}" &&tput cnorm && read par_impar && tput civis

	backup_bet=$initial_bet
	play_counter=0
	jugadas_malas=""

	echo -e "\n${greenColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inicial de${endColour} ${yellowColour}$initial_bet€${endColour} ${grayColour}a ${yellowColour}$par_impar${endColour}"
	while true; do
		money=$(($money-$initial_bet))
#		echo -e "\n${yellowColour}[+]${grayColour} Acabas de apostar ${yellowColour}$initial_bet€ ${grayColour}tu dinero actual es de: ${endColour}${yellowColour} $money€${endColour}\n"
		random_number="$(($RANDOM % 37))"
#		echo -e "${yellowColour}[+] ${grayColour}Ha salido el numero ${yellowColour}$random_number${endColour}"

		if [ "$money" -ge 0 ]; then
			if [ "$par_impar" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
#						echo -e "${redcolour}[+] ${grayColour}Ha salido el ${yellowColour}0, ${redColour}perdemos${endColour}"
						initial_bet=$(($initial_bet*2))
						jugadas_malas+="$random_number "

#						echo -e "${yellowColour}[+] ${grayColour}Te quedas en: ${yellowColour}$money€${endColour}"
					else
#						echo -e "${yellowColour}[+] ${grayColour}El numero ${yellowColour}$random_number es par, ${greenColour}¡GANASTE!${endColour}"
						reward=$(($initial_bet*2))
#						echo -e "${greenColour}[+] ${grayColour}Ganas un total de ${yellowColour}$reward€${endColour}"
						money=$(($money+$reward))
#						echo -e "${yellowColour}[+] ${grayColour}Tienes: ${yellowColour}$money€${endColour}"
						initial_bet=$backup_bet
						jugadas_malas=""
					fi
				else
#					echo -e "${redColour}[+] ${grayColour}El numero ${yellowColour}$random_number es impar, ${redColour}¡PERDEMOS!${endColour}"
					initial_bet=$(($initial_bet*2))
					jugadas_malas+="$random_number "
#					echo -e "${yellowColour}[+] ${grayColour}Te quedas en: ${yellowColour}$money€${endColour}"
				fi
			else
				# Toda esta definicion para numeros impares
                		if [ "$(($random_number % 2))" -eq 1 ]; then
#			                echo -e "${redColour}[+] ${grayColour}El numero ${yellowColour}$random_number es impar, ${greenColour}¡GANAS!${endColour}"
                                        reward=$(($initial_bet*2))
#                                       echo -e "${greenColour}[+] ${grayColour}Ganas un total de ${yellowColour}$reward€${endColour}"
                                        money=$(($money+$reward))
#                                       echo -e "${yellowColour}[+] ${grayColour}Tienes: ${yellowColour}$money€${endColour}"
                                        initial_bet=$backup_bet
                                        jugadas_malas=""
#      	                                echo -e "${yellowColour}[+] ${grayColour}Te quedas en: ${yellowColour}$money€${endColour}"

                                else

#	                                echo -e "${yellowColour}[+] ${grayColour}El numero ${yellowColour}$random_number es par, ${redColour}¡PIERDES!${endColour}"
                                	initial_bet=$(($initial_bet*2))
   	                                jugadas_malas+="$random_number "
                                fi
			fi
		else
			# Nos quedamos sin dinero
			echo -e "\n${redColour}[+] Te has quedado sin pasta CABRON!${endColour}\n"
			echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha habido un total de${endColour} ${yellowColour}$play_counter${grayColour} jugadas${endColour}\n"
			echo -e "${yellowColour}[+]${endColour} ${grayColour}A continuacion se van a representar los numeros con los que has palmado pasta chavalin:${endColour}\n"
			echo -e "${yellowColour}[ $jugadas_malas]${endColour}"
			tput cnorm; exit 0
		fi
		let play_counter+=1
	done
	tput cnorm; exit 0
}

function inverseLabrouchere(){
	tput civis
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con la tecnica${endColour}${yellowColour} $technique${endColour}\n"
	echo -e "${yellowColour}[+]${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour} $money€${endColour}\n"
	echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿A qué deseas apostar continuamente? (par/impar) --> ${endColour}${yellowColour}" &&tput cnorm && read par_impar && tput civis

	declare -a my_sequence=(1 2 3 4)
	declare -i jugadas_totales=0
	declare -i bet_to_renew=$(($money+50))

	echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Comenzamos con la secuencia ${endColour}${yellowColour}[${my_sequence[@]}]${endColour}\n"
	echo -e "${yellowColour}[+]${endColour} ${grayColour} El tope para renovar la secuencia se ha establecido por encima de: ${yellowColour}$bet_to_renew€${endColour}\n"
	echo -e "${yellowColour}[+]${endColour} ${grayColour} Tenemos ${yellowColour}$money€${endColour}\n"

	while true; do
		echo -e "${yellowColour}[+]${endColour} ${grayColour} Tenemos ${yellowColour}$money€${endColour}"

		let jugadas_totales+=1
		if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
			bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
			my_sequence=(${my_sequence[@]})
		elif [ "${#my_sequence[@]}" -eq 1 ]; then
			bet=${my_sequence[0]}
		else
                        echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
	                my_sequence=(1 2 3 4)
        	        echo -e "${yellowColour}[!] ${grayColour}Restablecemos la secuencia a ${yellowColour}[${my_sequence[@]}]${endColour}"
			bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
		fi
		money=$(($money-$bet))
		echo -e "${yellowColour}[+] ${grayColour}La secuencia se nos queda de la siguiente forma ${yellowColour}[${my_sequence[@]}]${endColour}\n"

		if [ "$money" -ge 0 ]; then
			random_number=$(($RANDOM % 37))
			echo -e "${yellowColour}[+]${grayColour} Acabas de apostar ${yellowColour}$bet€ ${grayColour}tu dinero actual es de: ${endColour}${yellowColour} $money€${endColour}"

			if [ "$par_impar" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
					echo -e "${greenColour}[+] ${grayColour}El numero ${yellowColour}$random_number ${grayColour}es par ${greenColour}¡ganas!${endColour}"

					reward=$(($bet*2))
					let money+=reward
					my_sequence+=($bet)
					my_sequence=(${my_sequence[@]})
				else
					if [ "$random_number" -eq 0 ]; then
						echo -e "${redColour}[!] ${grayColour}Ha salido el numero ${yellowColour}$random_number ${redColour}¡pierdes!${endColour}"
					else
						echo -e "${redColour}[!] ${grayColour}El numero ${yellowColour}$random_number ${grayColour}es impar ${redColour}¡pierdes!${endColour}"
					fi

					unset my_sequence[0]
					unset my_sequence[-1] 2>/dev/null
					my_sequence=(${my_sequence[@]})

				fi
			elif [ "$par_impar" == "impar" ]; then
				if [ "$(($random_number % 2))" -eq 1 ]; then
					echo -e "${greenColour}[+] ${grayColour}El numero ${yellowColour}$random_number ${grayColour}es impar ${greenColour}¡ganas!${endColour}"

					reward=$(($bet*2))
					let money+=reward
					my_sequence+=($bet)
					my_sequence=(${my_sequence[@]})
				else
					if [ "$random_number" -eq 0 ]; then
						echo -e "${redColour}[!] ${grayColour}Ha salido el numero ${yellowColour}$random_number ${redColour}¡pierdes!${endColour}"
					else
						echo -e "${redColour}[!] ${grayColour}El numero ${yellowColour}$random_number ${grayColour}es par ${redColour}¡pierdes!${endColour}"
					fi

					unset my_sequence[0]
					unset my_sequence[-1] 2>/dev/null
					my_sequence=(${my_sequence[@]})

				fi
			else
                        echo -e "\n${redColour}[!] ERROR: Introduce ${yellowColour}(par/impar)${endColour}" && tput cnorm && exit 1
			fi

			if [ $money -gt $bet_to_renew ]; then
				my_sequence=(1 2 3 4)
				bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
				my_sequence=(${my_sequence[@]})

				echo -e "${greenColour}[!]${endColour} ${grayColour} Se ha superado el limite establecido para renovar la secuencia de: ${yellowColour}$bet_to_renew€${endColour}"
				let bet_to_renew+=50
				echo -e "${greenColour}[+]${endColour} ${grayColour} Ahora el tope para renovar la secuencia se ha establecido por encima de: ${yellowColour}$bet_to_renew€${endColour}"
			elif [ $money -lt $(($bet_to_renew-100)) ]; then
				echo -e "${yellowColour}[!] ${grayColour}Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
					let bet_to_renew-=50
				echo -e "${yellowColour}[+]${endColour} ${grayColour} Ahora el tope para renovar la secuencia se ha establecido por encima de: ${yellowColour}$bet_to_renew€${endColour}"
			fi
		else
                        # Nos quedamos sin dinero
                        echo -e "\n${redColour}[!] Te has quedado sin pasta CABRON!${endColour}"
			echo -e "${yellowColour}[+] ${grayColour}Ha habido un total de ${purpleColour}$jugadas_totales${endColour}\n"
                        tput cnorm; exit 0
		fi
	done
	tput cnorm
}

while getopts "m:t:h" arg; do
        case $arg in
                m) money=$OPTARG;;
                t) technique="$OPTARG";;
                h) helpPanel;;
        esac
done

if [ $money ] && [ "$technique" ]; then
	if [ "$technique" == "martingala" ]; then
		martingala
	elif [ "$technique" == "inverseLabrouchere" ]; then
		inverseLabrouchere
	else
		echo -e "\n${redColour}[!] La tecnica introducida no exite${endColour}"
		helpPanel
	fi
else
	helpPanel
fi

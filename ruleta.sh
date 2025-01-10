#!/bin/bash



#	      dMMMMb  dMP     .aMMMb  .aMMMb  dMP dMP         .aMMMb  .aMMMb dMMMMMP	|> Ruleta ||
#	     dMP"dMP dMP     dMP"dMP dMP"VMP dMP.dMP         dMP"dMP dMP"VMP  .dMP" 	-> BlackACZ ©
#	    dMMMMK" dMP     dMMMMMP dMP     dMMMMK"         dMMMMMP dMP     .dMP"   	
#	   dMP.aMF dMP     dMP dMP dMP.aMP dMP"AMF         dMP dMP dMP.aMP.dMP"     
#	  dMMMMP" dMMMMMP dMP dMP  VMMMP" dMP dMP         dMP dMP  VMMMP"dMMMMMP    



#----------// Colours //-----------#
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
#----------------------------------#

function ctrl_c()
{
  echo -e "${redColour}\nSaliendo...\n${redColour}"
  tput cnorm; exit 1
}

trap ctrl_c INT

function helpPanel()
{
  echo -e "\n${redColour}[!]${endColour}${yellowColour} $0${endColour}\n"
  echo -e "\t-m) Dinero a utilizar"
  echo -e "\t-t) Técnica a utilizar ${blueColour}( [1] martingala | [2] inverseLabrouchere)${endColour}"
  echo -e "\n"
  exit 1
}

function martingala()
{
  echo -e "\n:: Dinero actual ${yellowColour}$money€ ${endColour}"
  read -p "[+] ¿Cúanto vamos a apostar? -> " apuesta_inicial
  read -p "[+] ¿A qué vamos a apostar (par | impar)? -> " par_impar
  
  while [ "$par_impar" != "par" ] &&  [ "$par_impar" != "Par" ] && [ "$par_impar" != "impar" ] && [ "$par_impar" != "Impar" ]; do
    echo -e "${redColour}[!]Esa opción no está disponible${endColour}, intenta con \"par\" o \"impar\" "
    read -p "[+] Entones ¿A qué vamos a apostar (par | impar)? -> " par_impar
  done

  echo -e "\nVamos a jugar con una apuesta inicial de $apuesta_inicial€ apostando a $par_impar"
  apuesta="$apuesta_inicial"
  play_counter=0
  defated_counter=0
  win_counter=0
  peak_of_mony=0
  bad_hand=" "

  while true; do  
  
    random_Num="$(( $RANDOM % 37 ))"
  
    if [ "$par_impar" == "par" ] || [ "$par_impar" == "Par" ]; then
      if [ $(( random_Num % 2 )) -eq 0 ] && [ "$random_Num" -ne 0 ]; then
        #echo -e "${greenColour}+ Par $random_Num, ¡Ganamos!${endColour}"
        money=$(( $money + $apuesta ))
        #echo -e "${greenColour} tenemos $money€, apostando $apuesta€${endColour}"
        let "play_counter++"; let "win_counter++"
        bad_hand=""
        peak_of_mony=$money
      else
        #echo -e "${redColour}- Impar $random_Num, Perdemos :/${endColour}"
        money=$(( $money - $apuesta ))
        apuesta=$(( $apuesta * 2 ))
        #echo -e "${redColour} Tenemos $money€, apostando $apuesta€${endColour}"
        let "play_counter++"; let "defated_counter++"
        bad_hand+="${redColour}- $random_Num "
      fi
    else
      if [ $(( random_Num % 2 )) -ne 0 ] && [ "$random_Num" -ne 0 ]; then
        #echo -e "${greenColour}+ Impar $random_Num, ¡Ganamos!${endColour}"
        money=$(( $money + $apuesta ))
        #echo -e "${greenColour}tenemos $money€, apostando $apuesta€${endColour}"
        let "play_counter++"; let "win_counter++"
        bad_hand=""
        let "peak_of_mony=$money"
      else
        #echo -e "${redColour}+ Par $random_Num, Perdemos :/${redColour}"
        money=$(( $money - $apuesta ))
        apuesta=$(( $apuesta * 2 ))
        #echo -e "${redColour}Tenemos $money€, apostando, $apuesta€${endColour}"
        let "play_counter++"; let "defated_counter++"
        bad_hand+="${redColour}- $random_Num "
      fi
    fi

    if [ "$money" -le 0 ] || [ "$money" -lt "$apuesta" ]; then
      echo -e "\n${redColour}-> T.T Juego terminado, te quedaste sin pasta cabrón ${endColour}"  
      echo -e "Resumen de la partida:"
      echo -e "\tVeces ganado:${greenColour} $win_counter${endColour}"
      echo -e "\tVeces perdido:${redColour} $defated_counter${endColour}"
      echo -e "\tVeces jugado:${purpleColour} $play_counter${endColour}"
      echo -e "\n Malas jugadas consecutivas: \n$bad_hand"
      echo -e "Máximo dinero obtenido $peak_of_mony€ "
      break 
    fi
  done
}

function InvLab()
{
  declare -a vector
  read -p "con cuantos números quieres empezar?? -> " x
  read -p "con que valor vamos a iniciar?? -> " y
  read -p "A qué le vamos a apostar -> " par_impar 
  read -p "A que ganancia empezamos a jugar con el dinero de la casa??" win_money 

  x=$(($x-1))

  for i in $(seq 0 $x); do
  aux=$(($y*$(($i+1))))
  vector[$i]=$aux
  done;
  
  play_counter=0
  defated_counter=0
  win_counter=0
  peak_of_mony=0
  bad_hand=" "
  win_money2=0
  #echo "-> Nuestros números son ${vector[@]}"

  while true; do
    
    if [ $money -gt $(($win_money + $win_money2 )) ]; then
      
        echo -e "${greenColour}Empezamos una nueva secuencia con el diinero ganado!${endColour}"
        read -p "con cuantos números quieres empezar?? -> " x
        read -p "con que valor vamos a iniciar?? -> " y
        read -p "A qué le vamos a apostar -> " par_impar
        read -p "A que ganancia empezamos a jugar con el dinero de la casa?? -> " win_money2

      x=$(($x-1))

      for i in $(seq 0 $x); do
        aux=$(($y*$(($i+1))))
        vector[$i]=$aux
      done;
 
    fi

    random_Num="$(( $RANDOM % 37 ))"
    vect_val=${#vector[@]}
    apuesta=$((${vector[0]} + ${vector[-1]} ))
    
    if [ $money -lt $apuesta ]; then
      echo -e "\n${redColour}-> No tenemos suficiente pasta${endColour}\n"

      echo -e "Resumen de la partida:"
      echo -e "\tVeces ganado:${greenColour} $win_counter${endColour}"
      echo -e "\tVeces perdido:${redColour} $defated_counter${endColour}"
      echo -e "\tVeces jugado:${purpleColour} $play_counter${endColour}"
      echo -e "\n Malas jugadas consecutivas: \n$bad_hand"
      echo -e "Máximo dinero obtenido $peak_of_mony€ "
      break 

      break 
    fi

    if [ "$par_impar" == "par" ] || [ "$par_impar" == "Par" ]; then
      if [ $(( random_Num % 2 )) -eq 0 ] && [ "$random_Num" -ne 0 ]; then
        echo -e "¡Ganamos! $random_Num"
        let "money+=$apuesta"
        echo "-> Nuestro Dinero: $money€"
        vector[$(($vect_val + 1))]=$apuesta
        vector=(${vector[@]})
        vect_val=${#vector[@]}


        ########
        if [ $vect_val -lt 2 ]; then
          echo -e "\n-> Nos quedamos sin jugadas"
          read -p "Apostamos de nuevo?? [Yes / No] -> " ret
          if [[ $ret != Yes ]]; then
            echo -e "\n-> Juego terminado" 
            echo -e "Resumen de la partida:"
            echo -e "\tVeces ganado:${greenColour} $win_counter${endColour}"
            echo -e "\tVeces perdido:${redColour} $defated_counter${endColour}"
            echo -e "\tVeces jugado:${purpleColour} $play_counter${endColour}"
            echo -e "\n Malas jugadas consecutivas: \n$bad_hand"
            echo -e "Máximo dinero obtenido $peak_of_mony€ "

            break 
          else
            read -p "con cuantos números quieres empezar?? -> " x
            read -p "con que valor vamos a iniciar?? -> " y
            read -p "A qué le vamos a apostar -> " par_impar 
            x=$(($x-1))
          fi
        fi
        #########
        let "play_counter++"; let "win_counter++"
        bad_hand=""
        peak_of_mony=$money

        echo "$vect_val"
        apuesta=$((${vector[0]} + ${vector[-1]} ))
        echo "-> vector ${vector[@]}"
        echo "-> apuesta $apuesta"
      else
        echo -e "Perdemos $random_Num"
        let "money-=$apuesta"
        echo "$money€"
        unset vector[0]
        unset vector[-1]
        vector=(${vector[@]})
        vect_val=${#vector[@]}

        let "play_counter++"; let "defated_counter++"
        bad_hand+="${redColour}- $random_Num "

          if [ $vect_val -lt 2 ]; then
            echo -e "\n-> Nos quedamos sin jugadas"
            read -p "Apostamos de nuevo?? [Yes / No] -> " ret
            
            if [[ $ret != Yes ]]; then

              echo -e "\n-> Juego terminado" 
              echo -e "Resumen de la partida:"
              echo -e "\tVeces ganado:${greenColour} $win_counter${endColour}"
              echo -e "\tVeces perdido:${redColour} $defated_counter${endColour}"
              echo -e "\tVeces jugado:${purpleColour} $play_counter${endColour}"
              echo -e "\n Malas jugadas consecutivas: \n$bad_hand"
              echo -e "Máximo dinero obtenido $peak_of_mony€ "

              break 
            else
              read -p "con cuantos números quieres empezar?? -> " x
              read -p "con que valor vamos a iniciar?? -> " y
              read -p "A qué le vamos a apostar -> " par_impar 

              for i in $(seq 0 $x); do
                aux=$(($y*$(($i+1))))
                vector[$i]=$aux
              done;
              x=$(($x-1))
            fi
          fi
        apuesta=$((${vector[0]} + ${vector[-1]} ))
        echo "-> vector ${vector[@]}"
        echo "-> apuesta $apuesta"
      fi
    else
        if [ $(( random_Num % 2 )) -ne 0 ] && [ "$random_Num" -ne 0 ]; then
          echo -e "¡Ganamos! $random_Num"
          let "money+=$apuesta"
          echo "-> Nuestro Dinero: $money€"
          vector[$(($vect_val + 1))]=$apuesta
          vector=(${vector[@]})
          vect_val=${#vector[@]}
          ########
          if [ $vect_val -lt 2 ]; then
            echo -e "\n-> Nos quedamos sin jugadas"
            read -p "Apostamos de nuevo?? [Yes / No] -> " ret
            if [[ $ret != Yes ]]; then
              echo -e "\n-> Juego terminado"
              echo -e "Resumen de la partida:"
              echo -e "\tVeces ganado:${greenColour} $win_counter${endColour}"
              echo -e "\tVeces perdido:${redColour} $defated_counter${endColour}"
              echo -e "\tVeces jugado:${purpleColour} $play_counter${endColour}"
              echo -e "\n Malas jugadas consecutivas: \n$bad_hand"
              echo -e "Máximo dinero obtenido $peak_of_mony€ "

              break 
          else
            read -p "con cuantos números quieres empezar?? -> " x
            read -p "con que valor vamos a iniciar?? -> " y
            read -p "A qué le vamos a apostar -> " par_impar 
            x=$(($x-1))
          fi
        fi
        #########

        let "play_counter++"; let "win_counter++"
        bad_hand=""
        peak_of_mony=$money

        echo "$vect_val"
        apuesta=$((${vector[0]} + ${vector[-1]} ))
        echo "-> vector ${vector[@]}"
        echo "-> apuesta $apuesta"
      else
        echo -e "Perdemos $random_Num"
        let "money-=$apuesta"
        echo "$money€"
        unset vector[0]
        unset vector[-1]
        vector=(${vector[@]})
        vect_val=${#vector[@]}
        
        let "play_counter++"; let "defated_counter++"
        bad_hand+="${redColour}- $random_Num "

          if [ $vect_val -lt 2 ]; then
            echo -e "\n-> Nos quedamos sin jugadas"
            read -p "Apostamos de nuevo?? [Yes / No] -> " ret
            
            if [[ $ret != Yes ]]; then
              echo -e "\n-> Juego terminado" 
              echo -e "Resumen de la partida:"
              echo -e "\tVeces ganado:${greenColour} $win_counter${endColour}"
              echo -e "\tVeces perdido:${redColour} $defated_counter${endColour}"
              echo -e "\tVeces jugado:${purpleColour} $play_counter${endColour}"
              echo -e "\n Malas jugadas consecutivas: \n$bad_hand"
              echo -e "Máximo dinero obtenido $peak_of_mony€ "

              break 
            else
              read -p "con cuantos números quieres empezar?? -> " x
              read -p "con que valor vamos a iniciar?? -> " y
              read -p "A qué le vamos a apostar -> " par_impar 

              for i in $(seq 0 $x); do
                aux=$(($y*$(($i+1))))
                vector[$i]=$aux
              done;
              x=$(($x-1))
            fi
          fi
        apuesta=$((${vector[0]} + ${vector[-1]} ))
        echo "-> vector ${vector[@]}"
        echo "-> apuesta $apuesta"
      fi
    fi
  done
}



while getopts "m:t:h" arg; do
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ] || [ "$technique" == "1" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ] || [ "$technique" == "2" ]; then
    echo -e ":: Inverse Labouchère [ En desarrollo ]"
    InvLab
  else
    echo -e "\n${redColour}La tecnica no existe${endColour}\n"
    helpPanel
  fi
else
  helpPanel
fi

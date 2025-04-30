#!/bin/bash
# Autor: Antonio Madrid Jaén [({'"¿Para que quieres ver las criptos? 🤨​"'})]

# Gracias s4vitar por:
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Si no tienes un paquete instalado no hacemos na!! 😜​
if ! dpkg -s html2text >/dev/null 2>&1; then
    echo -e "${redColour}[?] No tienes el paquete html2text, ¿quieres instalarlo? (S/n)${endColour}"
    read confirmacion
    if [[ $confirmacion =~ ^[Ss]$ || ! $confirmacion ]]; then
        sudo apt install html2text &>/dev/null
    else
        echo "${redColour}[!] Si no lo tienes no podremos ejecutar el script${endColour}"
    fi
fi

# Este es archivo es temporal, no va a pasar nada ​​🙂‍↕️​
echo '' >tmp.tmp

# Que si que si, que si haces ctrl + c vas a salir, no seas pesao
trap ctrl_c INT
function ctrl_c() {
    echo -e "\n${redColour}[!] Saliendo... ${endColour}"
    rm tmp.tmp
    exit 1
}

# Igual antes he sido un poco borde, para que me perdones te voy a hacer un panel de ayuda ​🥺​ (si no no funciona el script xd)
helpanel() {
    for i in {1..100}; do echo -n -e ${greenColour}"-"${endColour}; done
    echo -e "\n\n\t${yellowColour}e modo explorador\n\t\tunconfirmed_transactions vemos las transacciones ${endColour}"
    echo -e "\n\t${yellowColour}b poner en modo bucle ${endColour}"
    echo -e "\n\t${yellowColour}h panel de ayuda ${endColour}"
    rm tmp.tmp
    exit 1
}
if [ $# -eq 0 ]; then
    helpanel
    rm tmp.tmp
    exit 1
fi
contador=0
while getopts "e:bh" arg; do
    case $arg in
    b) bucle=1;;
    e)
        explorador="$OPTARG"
        let contador=$contador+1
        ;;
    h) helpanel ;;
    esac
done

# ¿Empezamos ya o que? Me aburrooooo 😴​

if [ $contador -eq 1 ]; then
    if [ $explorador == "unconfirmed_transactions" ]; then
        unconfirmed_transactions="https://www.blockchain.com/es/explorer/mempool/btc"
        fun_unconfirmed() {
            curl -s "$unconfirmed_transactions" | html2text > tmp.tmp
            hash=$(cat tmp.tmp | grep "hash" | cut -d "_" -f3)
            hash_array=($hash)
            criptos=$(cat tmp.tmp | grep '_BTC' | cut -d "_" -f1)
            criptos_array=($criptos)
            hora=$(cat tmp.tmp | grep ":" | tail -n +2 | tr "[_,]" "_")
            hora_array=($hora)
            dolares=$(cat tmp.tmp | grep '^\$' | sed 's/\$//g')
            dolares_array=($dolares)
            lineas=$(echo $hash | wc -w)

            clear

            printf "${turquoiseColour}+----------------------+----------------------+----------------------+---------------------+\n"
            printf "| %-20s | %-20s | %-20s | %-19s |\n" "Hash" "BTC" "Hora" "USD"
            printf "+----------------------+----------------------+----------------------+---------------------+\n${endColour}"
            for ((i = 0; $i < $lineas; i = $(($i + 1)))); do
                printf "${turquoiseColour}| %-20s | %-20s | %-20s | %-20s|\n" \
                    "${hash_array[$i]}" \
                    "${criptos_array[$i]} BTC" \
                    "${hora_array[$i]}" \
                    "${dolares_array[$i]} \$"
            done
            printf "${turquoiseColour}+----------------------+----------------------+----------------------+---------------------+\n${endColour}"
            rm tmp.tmp 2>/dev/null
        }
        if [ $bucle ]; then
            while true; do
                fun_unconfirmed
                sleep 5
            done
        else
            fun_unconfirmed
        fi
    else
        helpanel
        rm tmp.tmp
        exit 1
    fi
fi

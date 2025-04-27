#!/bin/bash
# Script de backup con 7zip
# Autor: Antonio Madrid jaén
# Fecha: 27/04/2025

if [ $UID != 0 ]; then
    echo "[!] Recomendable ejecutar el script con sudo"
fi

if [ "$#" -lt 2 ]; then
    echo -e "[-] Debes decirme como minimo dos rutas ten en cuenta que la ultima ruta sera donde se guardara la copia, las otras seran de donde hara los backups\nNO PROPORCIONES RUTAS RELATIVAS"
    exit 1
fi

if ! dpkg -s p7zip-full &>/dev/null; then
    read -p "[?] No tienes el paquete p7zip-full instalado ¿Quieres instalarlo? (S/n)" confirmacion
    if [[ "$confirmacion" =~ ^[Ss]$ ]]; then
        sudo apt install 7zip p7zip-full -y < /dev/null 2>&1
    else 
        echo -e "[-] No se va a istalar"
    fi
fi

ruta=${!#}
if [[ $ruta =~ /$ ]]; then
    ruta="$(echo ${ruta:0:-1})"
fi

for i in "$@"; do
    if [[ ! $i =~ ^/ ]]; then
        echo -e "[-] No proporciones rutas relativas"
        exit 1
    fi
done

for i in "${@:1:$(($#-1))}"; do
    nombre_backup="$(basename "$i")_$(date | sed 's/[:\ ]/_/g')"
    7z a "$ruta/$nombre_backup" "$i" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "[+] backup realizado correctamente de $i en $ruta $(date)" >> "$ruta/backup.log"
    else
        echo -e "[-] No se ha podido realizar el backup de $i en $ruta $(date)" >> "$ruta/backup.log"
    fi
done
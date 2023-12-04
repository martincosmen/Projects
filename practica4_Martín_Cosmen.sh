#!/bin/bash

# Verificar si el usuario es root
if [ "$(whoami)" != "root" ]; then
    echo "Este script debe ejecutarse como root. Por favor, utiliza sudo o inicia sesión como root."
    exit 1
fi

# Ruta al archivo de entrada
ficheropaq="paquetes.txt"

# Verificar si el archivo de entrada existe
if [ ! -e "$ficheropaq" ]; then
    echo "El archivo $ficheropaq no existe. Por favor, crea el archivo con el formato PACKAGENAME:ACTION."
    exit 1
fi

# Array para almacenar nombres de paquetes
declare -a nombre_paquetes=()

# Leer el archivo e iterar sobre las líneas
while IFS=: read -r nombre_paquete accion; do
    # Agregar el nombre del paquete al array
    nombre_paquetes+=("$nombre_paquete")

    case "$accion" in
        "add")
            echo "Añadiendo repositorio para el paquete $nombre_paquete"
            # Comprobar si el paquete tiene un repositorio específico
            case "$nombre_paquete" in
                "atom")
                    sudo add-apt-repository -y ppa:webupd8team/atom
                    ;;
                "gdebi")
                    sudo add-apt-repository -y ppa:mc3man/trusty-media
                    ;;
                "google-chrome")
                    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
                    ;;
                "brave")
                    sudo apt install -y apt-transport-https curl
                    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
                    ;;
                "vlc")
                    sudo add-apt-repository -y ppa:videolan/stable-daily
                    ;;
                # Agrega más casos según sea necesario
                *)
                    echo "No se encontró un repositorio específico para $nombre_paquete"
                    ;;
            esac
            # Actualizar la lista de paquetes después de agregar el repositorio
            sudo apt update
            ;;
        "remove" | "r")
            echo "Desinstalando el software $nombre_paquete"
            sudo apt remove -y "$nombre_paquete"
            sudo apt purge -y "$nombre_paquete"
            ;;
        "install" | "i")
            echo "Instalando el software $nombre_paquete"
            sudo apt install -y "$nombre_paquete"
            ;;
        "status" | "s")
            echo "Mostrando estado del software $nombre_paquete"
            dpkg -l | grep -q "$nombre_paquete" && echo "$nombre_paquete instalado" || echo "$nombre_paquete no instalado"
            ;;
        *)
            echo "Acción no válida para el paquete $nombre_paquete: $accion"
            ;;
    esac
done < "$ficheropaq"

# Fin del script

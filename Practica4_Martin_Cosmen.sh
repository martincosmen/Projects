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

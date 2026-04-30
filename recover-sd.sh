#!/usr/bin/env bash
# Recuperacion de fotos borradas de una microSD usando photorec (testdisk).
# Uso:
#   ./recover-sd.sh [carpeta_destino]              -> con imagen dd (mas seguro, ocupa el tamano de la SD)
#   ./recover-sd.sh --no-image [carpeta_destino]   -> directo sobre la SD (sin imagen, no ocupa espacio)
# Destino por defecto: ~/recovered_photos

set -euo pipefail

NO_IMAGE=0
if [[ "${1:-}" == "--no-image" ]]; then
    NO_IMAGE=1
    shift
fi

DEST="${1:-$HOME/recovered_photos}"

# 1. Dependencias
if ! command -v photorec >/dev/null 2>&1; then
    echo "photorec no instalado. Instalando con brew..."
    brew install testdisk
fi

mkdir -p "$DEST"

# 2. Identificar la SD
echo
echo "=== Discos externos detectados ==="
diskutil list external
echo
echo "Mete la SD si aun no lo has hecho y dale a Enter para refrescar, o escribe el identifier."
read -rp "Identifier de la SD (ej: disk4, sin /dev/): " DISK

if [[ -z "$DISK" ]]; then
    echo "Refresco:"
    diskutil list external
    read -rp "Identifier de la SD: " DISK
fi

DEV="/dev/$DISK"
RDEV="/dev/r$DISK"

if [[ ! -e "$DEV" ]]; then
    echo "ERROR: $DEV no existe"
    exit 1
fi

# 3. Confirmacion
echo
echo "Vas a leer $DEV. Verifica que es la SD correcta:"
diskutil info "$DEV" | grep -E "Device / Media Name|Disk Size|Protocol|Removable Media|Volume Name" || true
echo
read -rp "Confirma escribiendo SI: " CONF
[[ "$CONF" == "SI" ]] || { echo "Cancelado."; exit 1; }

# 4. Desmontar para que photorec pueda leer en raw
echo "Desmontando $DISK..."
diskutil unmountDisk "$DEV"

# 5. Imagen dd (opcional)
if [[ "$NO_IMAGE" -eq 1 ]]; then
    TARGET="$RDEV"
    echo
    echo "Modo --no-image: photorec leera directamente $RDEV (lectura solo, no escribe en la SD)."
else
    IMG="$DEST/sd_image.dd"
    if [[ -f "$IMG" ]]; then
        read -rp "Ya existe $IMG. Reusarla (r) o sobreescribir (s)? [r/s]: " OPT
        if [[ "$OPT" == "s" ]]; then
            rm -f "$IMG"
        fi
    fi

    if [[ ! -f "$IMG" ]]; then
        echo "Creando imagen en $IMG (puede tardar bastante segun tamano de la SD)..."
        sudo dd if="$RDEV" of="$IMG" bs=4m status=progress
        sudo chown "$(whoami)" "$IMG"
    fi
    TARGET="$IMG"
fi

# 6. Lanzar photorec
echo
echo "=== Lanzando photorec ==="
echo "En la TUI:"
echo "  1) Particion -> normalmente la unica que aparezca, o [Whole disk]"
echo "  2) Filesystem type -> [Other] (FAT/NTFS/exFAT)"
echo "  3) Free / Whole -> [Whole] para escanear todo el espacio"
echo "  4) Carpeta destino -> navega hasta $DEST y pulsa C"
echo
echo "Para filtrar solo fotos: en el menu File Opt antes de empezar,"
echo "pulsa 's' para deseleccionar todo y luego marca jpg, tif, png, raw, etc."
echo
read -rp "Enter para continuar..." _

if [[ "$NO_IMAGE" -eq 1 ]]; then
    sudo photorec "$TARGET"
else
    photorec "$TARGET"
fi

echo
echo "=== Hecho ==="
echo "Fotos recuperadas en subcarpetas recup_dir.* dentro de $DEST"
if [[ "$NO_IMAGE" -eq 0 ]]; then
    echo "Imagen original: $IMG (puedes borrarla si ya tienes lo que querias)"
fi

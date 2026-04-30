<div align="center">

# sd-rescue

**Recover deleted photos from a microSD card on macOS — for free.**
**Recupera fotos borradas de una tarjeta microSD en macOS — gratis.**

[Website](https://vikomittum.github.io/sd-rescue/) ·
[English](#english) ·
[Castellano](#castellano)

</div>

---

## English

### What is this?

`sd-rescue` is a single bash script that recovers deleted photos from a microSD card on macOS, using the open-source tool [PhotoRec](https://www.cgsecurity.org/wiki/PhotoRec) under the hood.

If you've ever had Disk Drill or similar paid tools tell you "we found 4,000 photos, that'll be $99 to recover them" — this gives you the same result for free, with one command.

### Why?

PhotoRec is excellent but its CLI is unfriendly: you have to figure out the right device, unmount it, decide whether to image it first, and navigate a TUI without context. This script wraps all that into a single guided flow with safe defaults.

### Requirements

- macOS (tested on Apple Silicon, works on Intel too)
- [Homebrew](https://brew.sh)
- A microSD card reader
- Disk space — see "Disk space" below

### Install

```bash
git clone https://github.com/vikomittum/sd-rescue.git
cd sd-rescue
chmod +x recover-sd.sh
```

### Usage

**Standard mode (safer, requires free disk space equal to the SD card size):**

```bash
./recover-sd.sh ~/Downloads/recovered
```

**No-image mode (no extra disk space needed, reads SD directly):**

```bash
./recover-sd.sh --no-image ~/Downloads/recovered
```

The script will:

1. Install `testdisk` via Homebrew if missing.
2. List external disks and ask you to identify your SD card.
3. Confirm the device twice (you really don't want to point this at the wrong disk).
4. Unmount the SD card.
5. Either create a `dd` image of the card (standard mode) or read it directly (`--no-image`).
6. Launch PhotoRec with the right target and tell you exactly which buttons to press.

### Disk space

`dd` images are bit-for-bit copies of the entire device. A 64 GB SD card → 64 GB image, regardless of how full it is. This is **the right behavior** for recovery: deleted files live in the "free" space, so you need to read all of it.

If you don't have that much free space, use `--no-image`. The trade-off: PhotoRec reads the card directly, so a single failed run means re-reading the card; with an image, retries are instant.

### Inside PhotoRec

When the TUI opens:

1. **Partition** — pick the only one that appears, or `[Whole disk]`.
2. **Filesystem type** — choose `[Other]` (works for FAT/exFAT/NTFS, which is what SDs use).
3. **Free / Whole** — pick `[Whole]` to scan all space, including deleted regions.
4. **Destination folder** — navigate to your recovery folder and press `C`.

Tip: to recover only photos, open `File Opt` first, press `s` to deselect everything, then enable `jpg`, `tif`, `png`, and any RAW format your camera uses (`cr2`, `nef`, `arw`, `raf`, etc.).

### What about a damaged SD?

If `dd` shows read errors (clicking sounds, "Input/output error"), the card has bad sectors. Use [`ddrescue`](https://www.gnu.org/software/ddrescue/) instead — it retries failed reads and skips around damaged areas. Open an issue if you'd like a flag for that.

### Safety

- The script never writes to the SD card. Both `dd` and PhotoRec only read.
- It asks twice before touching the device.
- Recovered files go to a folder you choose, not back to the SD.

### Donate

If this saved you a Disk Drill license fee, you can [drop a few euros via PayPal](https://vikomittum.github.io/sd-rescue/#donate). No pressure.

### License

MIT. See [LICENSE](LICENSE).

---

## Castellano

### ¿Qué es esto?

`sd-rescue` es un script de bash que recupera fotos borradas de una tarjeta microSD en macOS, apoyándose en [PhotoRec](https://www.cgsecurity.org/wiki/PhotoRec) (open source).

Si Disk Drill o similar te ha dicho alguna vez "hemos encontrado 4.000 fotos, son 99€ por recuperarlas" — esto hace lo mismo gratis, con un comando.

### ¿Por qué?

PhotoRec es buenísimo pero su CLI es áspera: hay que averiguar qué dispositivo es la SD, desmontarlo, decidir si crear imagen, y navegar una TUI sin contexto. Este script lo envuelve todo en un flujo guiado con defaults seguros.

### Requisitos

- macOS (probado en Apple Silicon, funciona también en Intel)
- [Homebrew](https://brew.sh)
- Lector de microSD
- Espacio en disco — ver "Espacio en disco" abajo

### Instalación

```bash
git clone https://github.com/vikomittum/sd-rescue.git
cd sd-rescue
chmod +x recover-sd.sh
```

### Uso

**Modo estándar (más seguro, necesita espacio libre igual al tamaño de la SD):**

```bash
./recover-sd.sh ~/Downloads/recuperadas
```

**Modo sin imagen (no necesita espacio extra, lee la SD directamente):**

```bash
./recover-sd.sh --no-image ~/Downloads/recuperadas
```

El script:

1. Instala `testdisk` con Homebrew si no lo tienes.
2. Lista los discos externos y te pide identificar tu SD.
3. Confirma el dispositivo dos veces (no quieres apuntar esto al disco equivocado).
4. Desmonta la SD.
5. O bien crea una imagen `dd` de la tarjeta (modo estándar), o lee directo (`--no-image`).
6. Lanza PhotoRec apuntando al sitio correcto y te dice qué botones pulsar.

### Espacio en disco

Las imágenes `dd` son copias bit a bit del dispositivo entero. Una SD de 64 GB → imagen de 64 GB, esté llena o vacía. Esto es **lo correcto** para recuperación: los archivos borrados viven en el espacio "libre", así que hay que leerlo todo.

Si no tienes tanto espacio, usa `--no-image`. El compromiso: PhotoRec lee la tarjeta directamente, así que si abortas tienes que volver a leer la SD entera; con imagen, los reintentos son instantáneos.

### Dentro de PhotoRec

Cuando se abra la TUI:

1. **Partition** — elige la única que aparezca, o `[Whole disk]`.
2. **Filesystem type** — `[Other]` (vale para FAT/exFAT/NTFS, que es lo que usan las SDs).
3. **Free / Whole** — `[Whole]` para escanear todo el espacio, incluyendo el borrado.
4. **Carpeta destino** — navega hasta tu carpeta de recuperación y pulsa `C`.

Tip: para recuperar solo fotos, abre `File Opt` antes de empezar, pulsa `s` para deseleccionar todo, y marca `jpg`, `tif`, `png`, y los RAW que use tu cámara (`cr2`, `nef`, `arw`, `raf`, etc.).

### ¿Y si la SD está dañada?

Si `dd` da errores de lectura (chasquidos, "Input/output error"), la tarjeta tiene sectores defectuosos. Usa [`ddrescue`](https://www.gnu.org/software/ddrescue/) en su lugar — reintenta lecturas fallidas y salta zonas dañadas. Abre un issue si quieres una flag para eso.

### Seguridad

- El script nunca escribe en la SD. Tanto `dd` como PhotoRec solo leen.
- Pregunta dos veces antes de tocar el dispositivo.
- Los archivos recuperados van a la carpeta que elijas, no de vuelta a la SD.

### Donar

Si esto te ha ahorrado la licencia de Disk Drill, puedes [dejar unos euros vía PayPal](https://vikomittum.github.io/sd-rescue/#donate). Sin presión.

### Licencia

MIT. Ver [LICENSE](LICENSE).

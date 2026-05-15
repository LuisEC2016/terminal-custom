# Pixegami Terminal Profile

Perfil de terminal para Ubuntu/Linux. El instalador configura ZSH, Oh My Zsh,
Powerlevel10k, fuentes RobotoMono, Powerline para Vim, una paleta Pixegami y
perfiles para Ptyxis y GNOME Terminal.

El estado actual del proyecto esta orientado a Ubuntu 26.04 LTS, Wayland,
GNOME 50 y Ptyxis. Los scripts tambien escriben un perfil Pixegami para GNOME
Terminal.

## Que instala

- ZSH como shell por defecto.
- Oh My Zsh usando el tema `powerlevel10k/powerlevel10k`.
- Plugins de Oh My Zsh: `git`, `z`, `fzf`, `extract`,
  `colored-man-pages`, `history`, `history-substring-search`,
  `zsh-syntax-highlighting` y `zsh-autosuggestions`.
- `fzf` en `~/.fzf` con atajos para historial, archivos y directorios.
- Powerline para Vim y una configuracion `.vimrc`.
- Fuentes RobotoMono Powerline incluidas en el repositorio.
- RobotoMono Nerd Font descargada desde Nerd Fonts.
- Configuracion de fontconfig para priorizar `RobotoMono Nerd Font Mono`.
- Paleta Pixegami para Ptyxis.
- Perfil Pixegami para GNOME Terminal.

## Requisitos

- Ubuntu/Linux con `sudo`.
- Sesion GNOME/Wayland recomendada.
- `git` instalado antes de ejecutar el instalador.
- Conexion a internet para `apt`, `pip`, `curl` y los repositorios GitHub que
  se clonan durante la instalacion.

Instalacion minima de prerrequisitos:

```bash
sudo apt update
sudo apt install -y git
```

## Instalacion

Ejecuta el instalador principal desde la raiz del repositorio:

```bash
./setup.sh
```

`setup.sh` no debe ejecutarse como root. El script hace limpieza de una
instalacion anterior, ejecuta los instaladores internos en orden y al final
indica si hace falta abrir una nueva sesion o correr `exec zsh`.

Internamente ejecuta:

```bash
bash install_powerline.sh
bash install_terminal.sh
bash install_profile.sh
```

## Cambios que hace en tu usuario

El instalador modifica archivos y configuraciones del usuario actual:

- Copia `configs/.vimrc` a `~/.vimrc`.
- Copia `configs/.zshrc` a `~/.zshrc`.
- Copia `configs/.p10k.zsh` a `~/.p10k.zsh`.
- Crea backups `~/.vimrc.bak` y `~/.zshrc.bak` si esos archivos existian.
- Instala fuentes en `~/.fonts/RobotoMono` y `~/.fonts/RobotoMonoNF`.
- Copia `configs/fonts.conf` a `~/.config/fontconfig/fonts.conf`.
- Copia `configs/fonts.conf` a `/etc/fonts/local.conf` con `sudo`.
- Instala la paleta en
  `~/.local/share/org.gnome.Ptyxis/palettes/pixegami.palette`.
- Cambia el shell por defecto a `zsh` con `chsh`.
- Escribe configuracion de Ptyxis y GNOME Terminal mediante `gsettings` y
  `dconf`.

Durante la limpieza, `setup.sh` tambien corrige ownership de instalaciones
previas hechas como root, elimina la fuente RobotoMono anterior en
`~/.fonts/RobotoMono`, resetea perfiles existentes de Ptyxis y reinicia el
perfil Pixegami de GNOME Terminal antes de recrearlo.

## Atajos configurados

- `Ctrl+R`: busqueda fuzzy en historial con `fzf`.
- `Ctrl+T`: busqueda fuzzy de archivos.
- `Alt+C`: salto fuzzy a directorios.
- `Arriba` / `Abajo`: busqueda de historial por substring.
- `Ctrl+Space` o flecha derecha: aceptar sugerencia completa.
- `x <archivo>`: extraer archivos usando el plugin `extract`.

## Archivos principales

| Archivo | Uso |
| --- | --- |
| `setup.sh` | Instalador principal. Limpia instalaciones anteriores y ejecuta los tres pasos de instalacion. |
| `install_powerline.sh` | Instala Powerline para Vim, fuentes RobotoMono Powerline, RobotoMono Nerd Font y fontconfig. |
| `install_terminal.sh` | Instala paquetes base (`git-core`, `zsh`, `curl`, `unzip`) e instala o actualiza Oh My Zsh. |
| `install_profile.sh` | Instala plugins, Powerlevel10k, `fzf`, copia configs y escribe perfiles de Ptyxis/GNOME Terminal. |
| `install.sh` | Instalador vendorizado de Oh My Zsh usado por `install_terminal.sh`. |
| `configs/.zshrc` | Configuracion ZSH activa. Carga Oh My Zsh, Powerlevel10k, plugins, aliases, historial, fzf, NVM y SDKMAN si existen. |
| `configs/.p10k.zsh` | Configuracion activa de Powerlevel10k con la paleta Pixegami. |
| `configs/.vimrc` | Configuracion Vim con Powerline y ajustes de edicion. |
| `configs/pixegami.palette` | Paleta Pixegami para Ptyxis. |
| `configs/fonts.conf` | Configuracion fontconfig para priorizar Nerd Font y evitar conflictos con glifos Powerline. |
| `configs/terminal_profile.dconf` | Dump legacy de GNOME Terminal conservado como referencia. No lo cargan los scripts actuales. |
| `configs/pixegami-agnoster.zsh-theme` | Tema ZSH legado. Existe en el repositorio, pero la instalacion actual usa Powerlevel10k. |
| `fonts/RobotoMono/` | Fuentes Roboto Mono for Powerline incluidas localmente. |

## Perfil y tema

La configuracion actual usa `RobotoMono Nerd Font Mono 14`, paleta Pixegami y
Powerlevel10k en modo `nerdfont-v3`. El prompt muestra directorio, estado de
Git, estado del ultimo comando, tiempo de ejecucion, entornos `virtualenv` o
`conda`, jobs en background y hora.

Ptyxis usa el UUID de perfil:

```text
fb358fc9-49ea-4252-ad34-1d25c649e633
```

GNOME Terminal usa el UUID de perfil:

```text
b1dcc9dd-5262-4d8d-a863-c897e6d979b9
```

## Desinstalacion o reversa manual

No hay un script de desinstalacion. Para revertir manualmente:

- Restaura `~/.vimrc.bak` y `~/.zshrc.bak` si quieres volver a tus configs
  anteriores.
- Cambia tu shell por defecto de vuelta a Bash si lo necesitas:

```bash
chsh -s "$(command -v bash)"
```

- Elimina o ajusta los perfiles Pixegami desde las preferencias de Ptyxis y
  GNOME Terminal.
- Revisa `~/.fonts/RobotoMono`, `~/.fonts/RobotoMonoNF`,
  `~/.config/fontconfig/fonts.conf` y `/etc/fonts/local.conf` si quieres quitar
  las fuentes/configuracion instaladas.

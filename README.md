# Pixegami Terminal Profile

Configuracion de terminal para Ubuntu/Linux. Instala ZSH con Oh My Zsh,
Powerlevel10k, algunas herramientas CLI utiles, tmux, neovim, fuentes
RobotoMono y una paleta Pixegami para Ptyxis y GNOME Terminal.

Probado en Ubuntu 26.04 LTS con Wayland, GNOME 50 y Ptyxis.

---

## Instalacion

```bash
sudo apt install -y git   # unico prerequisito
./setup.sh
```

No ejecutar como root. Al terminar muestra todos los atajos disponibles.

### Pasos internos

```
[1/4] install_powerline.sh   Powerline para Vim + fuentes RobotoMono
[2/4] install_tools.sh       Herramientas CLI para programadores
[3/4] install_terminal.sh    ZSH + Oh My Zsh
[4/4] install_profile.sh     Plugins, Powerlevel10k, fzf, configs, Ptyxis/GNOME Terminal
```

---

## Aliases — navegacion de archivos

| Comando | Descripcion |
|---|---|
| `ls` | Lista con iconos Nerd Font y directorios primero (eza) |
| `ll` | Lista larga con permisos, tamaño, fecha e icono de estado git |
| `la` | Lista todos los archivos incluidos ocultos |
| `lt` | Lista ordenada por fecha de modificacion (mas reciente arriba) |
| `ltree` | Arbol de directorios 3 niveles con iconos y estado git |
| `ltree2` | Arbol de directorios 2 niveles con iconos |
| `..` | Subir un nivel (`cd ..`) |
| `...` | Subir dos niveles |
| `....` | Subir tres niveles |
| `mkdir` | Crear directorios incluyendo padres, con confirmacion |
| `cp` | Copiar con confirmacion si sobreescribe |
| `mv` | Mover con confirmacion si sobreescribe |

---

## Aliases — visualizacion de archivos

| Comando | Descripcion |
|---|---|
| `cat` | Ver archivo con syntax highlighting y numeros de linea (bat) |
| `batp` | Ver archivo con paginacion (bat --paging=always) |
| `bh` | Ver archivo sin decoraciones ni numeros (bat --plain) |
| `man <cmd>` | Manual con colores via bat |

---

## Aliases — busqueda

| Comando | Descripcion |
|---|---|
| `grep` | Busqueda rapida con ripgrep respetando .gitignore |
| `rg` | ripgrep directo con todas sus opciones |

---

## Aliases — git

Ademas de todos los aliases del plugin `git` de OMZ (`gst`, `gco`, `gp`, `gl`, `gd`, `gcmsg`, etc.):

| Comando | Descripcion |
|---|---|
| `glog` | Log grafico compacto de todas las ramas |
| `gundo` | Deshacer ultimo commit manteniendo los cambios (`reset --soft HEAD~1`) |
| `gstash` | Crear stash con nombre (`git stash push -m`) |
| `gclean` | Eliminar archivos y directorios sin seguimiento (`git clean -fd`) |
| `gwip` | Hacer commit rapido con mensaje "wip: trabajo en progreso" |
| `gunwip` | Deshacer el ultimo commit wip |
| `diff` | Diff con syntax highlighting y numeros de linea (delta) |
| `lg` | Abrir lazygit — UI TUI completa para git |

---

## Aliases — tmux

> Solo disponibles si tmux esta instalado.

| Comando | Descripcion |
|---|---|
| `ta <nombre>` | Conectarse a una sesion tmux existente |
| `tl` | Listar todas las sesiones tmux activas |
| `ts <nombre>` | Crear nueva sesion tmux con nombre |
| `tk <nombre>` | Matar una sesion tmux |
| `td` | Desconectarse de la sesion actual (detach) |

---

## Aliases — sistema

| Comando | Descripcion |
|---|---|
| `top` | Monitor visual de CPU, RAM, disco y red (btop) |
| `df` | Espacio en disco visual y legible (duf) |
| `du` | Uso de disco interactivo navegable (ncdu --color dark) |
| `free` | Memoria con unidades legibles |
| `ports` | Listar puertos en escucha con proceso (`ss -tulnp`) |
| `myip` | Mostrar IP publica externa |
| `pbcopy` | Copiar stdin al portapapeles (wl-copy o xclip) |
| `pbpaste` | Pegar portapapeles a stdout |

---

## Aliases — desarrollo

| Comando | Descripcion |
|---|---|
| `py` | `python3` |
| `pip` | `pip3` |
| `serve` | Servidor HTTP en el directorio actual (`python3 -m http.server`) |
| `json` | Formatear JSON desde stdin (`python3 -m json.tool`) |
| `urlencode` | URL-encodear texto desde stdin |
| `vim` / `vi` | Neovim (si esta instalado) |
| `md` | Renderizar archivo Markdown con colores (glow) |
| `readme` | Renderizar README.md del directorio actual (glow) |

---

## Funciones ZSH

| Funcion | Descripcion |
|---|---|
| `mkd <dir>` | Crear directorio y entrar en el en un solo comando |
| `fcd` | Navegar directorios con fzf + preview de arbol (eza) |
| `fopen` | Buscar archivo con fzf + preview (bat) y abrirlo en `$EDITOR` |
| `fkill [sig]` | Seleccionar proceso con fzf y matarlo (por defecto -9) |
| `extract <archivo>` | Descomprimir cualquier formato: tar, gz, bz2, zip, 7z, rar |
| `envsource [archivo]` | Cargar variables de `.env` de forma segura (por defecto `.env`) |
| `bench <N> <cmd>` | Ejecutar `cmd` N veces midiendo el tiempo de cada iteracion |
| `port <numero>` | Mostrar que proceso esta usando ese puerto |
| `sizerank [N]` | Top N elementos mas pesados del directorio actual (defecto: 20) |
| `watchfile <archivo>` | Seguir cambios en un archivo en tiempo real con syntax highlighting |

---

## Atajos de teclado — ZSH / fzf

| Atajo | Accion |
|---|---|
| `Ctrl+R` | Busqueda fuzzy en historial de comandos |
| `Ctrl+T` | Busqueda fuzzy de archivos con preview (bat) |
| `Alt+C` | Saltar a directorio con fzf y preview de arbol (eza) |
| `Ctrl+/` | Mostrar u ocultar panel de preview en fzf |
| `Ctrl+U` | Pagina arriba en preview de fzf |
| `Ctrl+D` | Pagina abajo en preview de fzf |
| `↑` / `↓` | Buscar en historial por substring (history-substring-search) |
| `→` | Aceptar sugerencia completa de autosuggestions |
| `Ctrl+Space` | Aceptar sugerencia completa de autosuggestions |
| `Ctrl+G` | Abrir cheatsheets interactivos (navi) |

---

## Aliases — navegacion rapida (zoxide)

> Solo disponibles si zoxide esta instalado.

| Comando | Descripcion |
|---|---|
| `z <parte>` | Saltar al directorio mas visitado que coincide con el patron |
| `j <parte>` | Alias de `z` |
| `zi` | Selector interactivo de directorios con fzf (zoxide interactive) |
| `ji` | Alias de `zi` |

---

## Atajos de teclado — tmux

**Prefijo:** `Ctrl+A`

### Sesiones y ventanas

| Atajo | Accion |
|---|---|
| `Prefijo + c` | Nueva ventana en el directorio actual |
| `Prefijo + ,` | Renombrar ventana actual |
| `Shift+←` | Ir a la ventana anterior |
| `Shift+→` | Ir a la ventana siguiente |
| `Prefijo + &` | Cerrar ventana actual (con confirmacion) |

### Paneles (splits)

| Atajo | Accion |
|---|---|
| `Prefijo + \|` | Split vertical (panel a la derecha) |
| `Prefijo + -` | Split horizontal (panel abajo) |
| `Ctrl+H` | Mover al panel izquierdo |
| `Ctrl+J` | Mover al panel inferior |
| `Ctrl+K` | Mover al panel superior |
| `Ctrl+L` | Mover al panel derecho |
| `Alt+H` | Reducir panel 5 columnas hacia la izquierda |
| `Alt+J` | Reducir panel 5 filas hacia abajo |
| `Alt+K` | Reducir panel 5 filas hacia arriba |
| `Alt+L` | Ampliar panel 5 columnas hacia la derecha |
| `Prefijo + x` | Cerrar panel actual (con confirmacion) |

### Copiar y pegar

| Atajo | Accion |
|---|---|
| `Prefijo + [` | Entrar en modo copia (vi) |
| `v` | Iniciar seleccion (en modo copia) |
| `Ctrl+V` | Activar seleccion rectangular (en modo copia) |
| `y` | Copiar seleccion al portapapeles (wl-copy / xclip) |
| `Prefijo + ]` | Pegar desde buffer de tmux |

### Configuracion

| Atajo | Accion |
|---|---|
| `Prefijo + r` | Recargar `~/.tmux.conf` sin reiniciar |
| `Prefijo + d` | Desconectarse de la sesion (detach) |
| `Prefijo + s` | Selector de sesiones |
| `Prefijo + $` | Renombrar sesion actual |

---

## Atajos de teclado — Vim

**Lider:** `Space`

### Archivos y buffers

| Atajo | Descripcion |
|---|---|
| `Space+e` | Abrir explorador de archivos (netrw, vista arbol) |
| `Space+E` | Abrir explorador en panel lateral (Vexplore) |
| `Space+f` | Buscar archivo con fzf |
| `Space+b` | Selector de buffers abiertos |
| `Space+q` | Cerrar buffer actual sin cerrar la ventana |
| `Ctrl+S` | Guardar archivo (normal e insercion) |

### Splits y navegacion

| Atajo | Descripcion |
|---|---|
| `Space+v` | Abrir split vertical |
| `Space+s` | Abrir split horizontal |
| `Ctrl+H` | Ir al split izquierdo |
| `Ctrl+J` | Ir al split inferior |
| `Ctrl+K` | Ir al split superior |
| `Ctrl+L` | Ir al split derecho |
| `Ctrl+T` | Abrir terminal integrada en split inferior |
| `Esc` | Salir del modo terminal a modo normal |

### Busqueda

| Atajo | Descripcion |
|---|---|
| `Space+h` | Limpiar resaltado de busqueda |
| `Space+r` | Buscar patron en el proyecto con ripgrep |
| `Space+w` | Buscar la palabra bajo el cursor en el proyecto |
| `Space+co` | Abrir ventana quickfix con resultados |
| `Space+cc` | Cerrar ventana quickfix |
| `[q` | Ir al resultado anterior en quickfix |
| `]q` | Ir al resultado siguiente en quickfix |

### Edicion

| Atajo | Descripcion |
|---|---|
| `J` (visual) | Mover lineas seleccionadas hacia abajo |
| `K` (visual) | Mover lineas seleccionadas hacia arriba |
| `<` (visual) | Indentar a la izquierda manteniendo seleccion |
| `>` (visual) | Indentar a la derecha manteniendo seleccion |
| `Tab` (normal) | Saltar al bracket/parentesis que hace match |
| `(` `{` `[` `"` `'` | Auto-cierre del par en modo insercion |

---

## Atajos de teclado — Neovim

Neovim usa la misma logica de atajos que Vim (lider `Space`, splits con `Ctrl+hjkl`, `Ctrl+S` para guardar, `Ctrl+T` para terminal). Las diferencias:

| Atajo | Descripcion |
|---|---|
| `Space+e` | Explorador de archivos (netrw arbol) |
| `Space+f` | Buscar archivo con fzf |
| `Space+v` | Split vertical |
| `Space+s` | Split horizontal |
| `Space+q` | Cerrar buffer |
| `Space+h` | Limpiar resaltado |

---

## Herramientas CLI — referencia rapida

| Herramienta | Uso tipico |
|---|---|
| `bat <archivo>` | Ver archivo con colores |
| `fd <patron>` | Buscar archivos: `fd -e py`, `fd -t d src` |
| `rg <patron>` | Buscar en codigo: `rg "func main" --type go` |
| `delta` | Usado automaticamente por git diff/log/show |
| `lazygit` | `lg` — UI TUI para git |
| `btop` | Monitor de sistema (reemplaza top/htop) |
| `ncdu` | `du` — explorador de disco interactivo |
| `duf` | `df` — espacio en disco visual |
| `jq <filtro>` | `curl api/… \| jq '.data[]'` |
| `yq <filtro>` | `yq '.services' docker-compose.yml` |
| `tldr <cmd>` | `tldr git`, `tldr tar`, `tldr curl` |
| `entr` | `fd -e go \| entr go test ./…` — re-ejecutar al cambiar |
| `pv` | `cat file \| pv \| gzip > file.gz` — progreso en pipe |
| `glow <archivo>` | Render de Markdown con colores |
| `http <url>` | Cliente HTTP: `http GET api.ejemplo.com/users` |
| `shellcheck <script>` | Lint de scripts bash/sh |
| `parallel` | Ejecutar comandos en paralelo |

---

## Archivos del repositorio

| Archivo | Uso |
|---|---|
| `setup.sh` | Instalador principal (4 pasos) |
| `install_powerline.sh` | Powerline para Vim y fuentes RobotoMono |
| `install_tools.sh` | Herramientas CLI para programadores |
| `install_terminal.sh` | Paquetes base + Oh My Zsh |
| `install_profile.sh` | Plugins, Powerlevel10k, fzf, configs, Ptyxis/GNOME Terminal |
| `install.sh` | Instalador vendorizado de Oh My Zsh |
| `configs/.zshrc` | ZSH: OMZ, p10k, plugins, aliases, funciones, integraciones |
| `configs/.p10k.zsh` | Configuracion de Powerlevel10k con paleta Pixegami |
| `configs/.vimrc` | Vim: Powerline, fzf, ripgrep, splits, terminal, atajos |
| `configs/init.lua` | Neovim: configuracion Lua completa |
| `configs/.tmux.conf` | tmux: paleta Pixegami, modo vi, portapapeles Wayland |
| `configs/pixegami.palette` | Paleta Pixegami para Ptyxis |
| `configs/fonts.conf` | Fontconfig para priorizar Nerd Font |
| `configs/terminal_profile.dconf` | Dump legacy de GNOME Terminal (referencia) |
| `fonts/RobotoMono/` | Fuentes Roboto Mono for Powerline incluidas |

---

## Perfiles de terminal

| Terminal | UUID |
|---|---|
| Ptyxis | `fb358fc9-49ea-4252-ad34-1d25c649e633` |
| GNOME Terminal | `b1dcc9dd-5262-4d8d-a863-c897e6d979b9` |

---

## Desinstalacion manual

```bash
# Restaurar configs anteriores
cp ~/.vimrc.bak ~/.vimrc
cp ~/.zshrc.bak ~/.zshrc

# Volver a bash
chsh -s "$(command -v bash)"

# Eliminar fuentes instaladas
rm -rf ~/.fonts/RobotoMono ~/.fonts/RobotoMonoNF

# Quitar configs de editores y tmux
rm -f ~/.tmux.conf ~/.config/nvim/init.lua
```

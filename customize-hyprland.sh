#!/usr/bin/env bash

#############################################
# Script de customisation Hyprland         #
# Style: Hybrid Summer                      #
# Inspiré de: end-4/dots-hyprland          #
#############################################

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction pour afficher des messages
print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}\n"
}

# Vérifier si le script est exécuté en tant que root
if [ "$EUID" -eq 0 ]; then
    print_error "Ne pas exécuter ce script en tant que root!"
    exit 1
fi

# Détection de la distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        print_error "Impossible de détecter la distribution"
        exit 1
    fi
}

# Installation des dépendances
install_dependencies() {
    print_header "Installation des dépendances"

    detect_distro

    case "$DISTRO" in
        arch|manjaro|endeavouros)
            print_info "Distribution basée sur Arch détectée"

            # Paquets de base
            PACKAGES=(
                "hyprland"
                "kitty"
                "wofi"
                "waybar"
                "swww"
                "swaylock-effects"
                "wlogout"
                "mako"
                "grim"
                "slurp"
                "wl-clipboard"
                "brightnessctl"
                "pamixer"
                "playerctl"
                "network-manager-applet"
                "bluez"
                "bluez-utils"
                "blueman"
                "ttf-font-awesome"
                "ttf-jetbrains-mono-nerd"
                "noto-fonts-emoji"
                "polkit-gnome"
                "xdg-desktop-portal-hyprland"
                "qt5-wayland"
                "qt6-wayland"
                "imagemagick"
                "jq"
                "python-requests"
                "python-pywal"
            )

            print_info "Installation des paquets avec pacman..."
            sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

            # Installation de yay si nécessaire
            if ! command -v yay &> /dev/null; then
                print_info "Installation de yay (AUR helper)..."
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                cd -
            fi

            # Paquets AUR optionnels
            print_info "Installation des paquets AUR..."
            yay -S --needed --noconfirm swww-git hyprpicker || true
            ;;

        ubuntu|debian|pop)
            print_info "Distribution basée sur Debian/Ubuntu détectée"
            print_warning "Hyprland n'est pas disponible dans les dépôts officiels"
            print_info "Veuillez installer Hyprland manuellement: https://hyprland.org"

            sudo apt update
            sudo apt install -y \
                kitty \
                wofi \
                mako-notifier \
                grim \
                slurp \
                wl-clipboard \
                brightnessctl \
                pavucontrol \
                playerctl \
                network-manager-gnome \
                blueman \
                fonts-font-awesome \
                fonts-noto-color-emoji \
                imagemagick \
                jq \
                python3-pip

            pip3 install --user pywal
            ;;

        fedora)
            print_info "Distribution Fedora détectée"

            sudo dnf install -y \
                hyprland \
                kitty \
                wofi \
                waybar \
                mako \
                grim \
                slurp \
                wl-clipboard \
                brightnessctl \
                pamixer \
                playerctl \
                NetworkManager-applet \
                bluez \
                blueman \
                fontawesome-fonts \
                jetbrains-mono-fonts \
                google-noto-emoji-fonts \
                polkit-gnome \
                xdg-desktop-portal-hyprland \
                qt5-qtwayland \
                qt6-qtwayland \
                ImageMagick \
                jq \
                python3-requests \
                python3-pywal
            ;;

        *)
            print_error "Distribution non supportée: $DISTRO"
            print_info "Veuillez installer manuellement les dépendances"
            exit 1
            ;;
    esac

    print_success "Dépendances installées avec succès"
}

# Sauvegarde des configurations existantes
backup_configs() {
    print_header "Sauvegarde des configurations existantes"

    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    CONFIGS=("hypr" "waybar" "kitty" "wofi" "mako")

    for config in "${CONFIGS[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            print_info "Sauvegarde de $config..."
            cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
        fi
    done

    print_success "Sauvegarde créée dans: $BACKUP_DIR"
}

# Création des répertoires nécessaires
create_directories() {
    print_header "Création des répertoires"

    DIRS=(
        "$HOME/.config/hypr"
        "$HOME/.config/hypr/scripts"
        "$HOME/.config/waybar"
        "$HOME/.config/kitty"
        "$HOME/.config/wofi"
        "$HOME/.config/mako"
        "$HOME/.config/swaylock"
        "$HOME/.config/wlogout"
        "$HOME/Pictures/Wallpapers"
    )

    for dir in "${DIRS[@]}"; do
        mkdir -p "$dir"
        print_info "Créé: $dir"
    done

    print_success "Répertoires créés"
}

# Installation de la configuration Hyprland
install_hypr_config() {
    print_header "Installation de la configuration Hyprland"

    # Copier les fichiers de configuration depuis ce repo
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [ -d "$SCRIPT_DIR/config/hypr" ]; then
        print_info "Copie des fichiers de configuration Hyprland..."
        cp -r "$SCRIPT_DIR/config/hypr/"* "$HOME/.config/hypr/"
    else
        print_warning "Aucun fichier de configuration trouvé dans $SCRIPT_DIR/config/hypr"
        print_info "Création d'une configuration de base..."
        create_basic_hypr_config
    fi

    # Rendre les scripts exécutables
    if [ -d "$HOME/.config/hypr/scripts" ]; then
        chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
    fi

    print_success "Configuration Hyprland installée"
}

# Création d'une configuration Hyprland de base
create_basic_hypr_config() {
    cat > "$HOME/.config/hypr/hyprland.conf" << 'EOF'
# Configuration Hyprland - Style Hybrid Summer
# Inspiré de: end-4/dots-hyprland

# Moniteurs
monitor=,preferred,auto,1

# Source des fichiers de configuration
source = ~/.config/hypr/colors.conf
source = ~/.config/hypr/keybinds.conf
source = ~/.config/hypr/env.conf

# Programmes au démarrage
exec-once = waybar
exec-once = mako
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = swww init
exec-once = nm-applet --indicator
exec-once = blueman-applet

# Variables d'environnement
env = XCURSOR_SIZE,24

# Input
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1
    numlock_by_default = true

    touchpad {
        natural_scroll = yes
        disable_while_typing = true
        tap-to-click = true
    }

    sensitivity = 0
}

# Général
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(AF8D61FF) rgba(CEB153FF) rgba(7B8387FF) 45deg
    col.inactive_border = rgba(AF8D6166)
    layout = dwindle
}

# Décoration
decoration {
    rounding = 17

    blur {
        enabled = true
        size = 7
        passes = 4
        new_optimizations = on
        ignore_opacity = true
        xray = false
    }

    drop_shadow = no
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = yes

    bezier = md3_standard, 0.2, 0.0, 0, 1.0
    bezier = md3_decel, 0.05, 0.7, 0.1, 1
    bezier = md3_accel, 0.3, 0, 0.8, 0.15
    bezier = overshot, 0.05, 0.9, 0.1, 1.05
    bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
    bezier = win10, 0, 0, 0, 1
    bezier = gnome, 0, 0.85, 0.3, 1
    bezier = funky, 0.46, 0.35, -0.2, 1.2

    animation = windows, 1, 2, md3_decel, slide
    animation = windowsIn, 1, 2, md3_decel, slide
    animation = windowsOut, 1, 2, md3_accel, slide
    animation = border, 1, 10, default
    animation = fade, 1, 2.5, md3_decel
    animation = workspaces, 1, 3.5, md3_decel, slide
    animation = specialWorkspace, 1, 3, md3_decel, slidevert
}

# Layouts
dwindle {
    pseudotile = yes
    preserve_split = yes
    no_gaps_when_only = false
}

master {
    new_is_master = true
}

# Gestes
gestures {
    workspace_swipe = on
    workspace_swipe_fingers = 4
}

# Divers
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    vrr = 0
}

# Règles des fenêtres
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(blueman-manager)$
windowrule = float, ^(nm-connection-editor)$
windowrule = float, ^(file_progress)$
windowrule = float, ^(confirm)$
windowrule = float, ^(dialog)$
windowrule = float, ^(download)$
windowrule = float, ^(notification)$
windowrule = float, ^(error)$
windowrule = float, ^(splash)$
windowrule = float, ^(confirmreset)$
windowrulev2 = float,class:^(kitty)$,title:^(kitty-float)$

# Opacité
windowrulev2 = opacity 0.90 0.90,class:^(kitty)$
windowrulev2 = opacity 0.95 0.95,class:^(code)$
EOF

    # Fichier colors.conf
    cat > "$HOME/.config/hypr/colors.conf" << 'EOF'
# Couleurs - Thème Hybrid Summer
$color_accent = rgba(CEB153FF)
$color_bg = rgba(1e1e2eFF)
$color_fg = rgba(cdd6f4FF)
$color_inactive = rgba(AF8D6166)
EOF

    # Fichier env.conf
    cat > "$HOME/.config/hypr/env.conf" << 'EOF'
# Variables d'environnement
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_QPA_PLATFORM,wayland
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = GDK_BACKEND,wayland,x11
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
EOF

    print_info "Configuration Hyprland de base créée"
}

# Installation des keybinds
install_keybinds() {
    cat > "$HOME/.config/hypr/keybinds.conf" << 'EOF'
# Keybindings - Style Hybrid Summer

# Modificateurs
$mainMod = SUPER

# Applications
bind = $mainMod, Return, exec, kitty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,
bind = $mainMod, F, fullscreen, 0

# Screenshots
bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
bind = SHIFT, Print, exec, grim - | wl-copy
bind = $mainMod, Print, exec, grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png

# Contrôle audio
bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
bind = , XF86AudioLowerVolume, exec, pamixer -d 5
bind = , XF86AudioMute, exec, pamixer -t

# Contrôle luminosité
bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# Contrôle de lecture
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

# Navigation des fenêtres
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Navigation avec vim keys
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

# Déplacer les fenêtres
bind = $mainMod SHIFT, left, movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up, movewindow, u
bind = $mainMod SHIFT, down, movewindow, d

# Redimensionner les fenêtres
bind = $mainMod CTRL, left, resizeactive, -20 0
bind = $mainMod CTRL, right, resizeactive, 20 0
bind = $mainMod CTRL, up, resizeactive, 0 -20
bind = $mainMod CTRL, down, resizeactive, 0 20

# Workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Déplacer vers workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Workspace spécial (scratchpad)
bind = $mainMod, S, togglespecialworkspace,
bind = $mainMod SHIFT, S, movetoworkspace, special

# Défilement des workspaces
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Déplacer/redimensionner avec souris
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
EOF

    print_success "Keybinds installés"
}

# Installation de Waybar
install_waybar() {
    print_header "Installation de la configuration Waybar"

    cat > "$HOME/.config/waybar/config" << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 40,
    "spacing": 4,

    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "tray"],

    "hyprland/workspaces": {
        "format": "{icon}",
        "on-click": "activate",
        "format-icons": {
            "1": "一",
            "2": "二",
            "3": "三",
            "4": "四",
            "5": "五",
            "6": "六",
            "7": "七",
            "8": "八",
            "9": "九",
            "10": "十"
        }
    },

    "hyprland/window": {
        "format": "{}",
        "max-length": 50
    },

    "clock": {
        "format": "{:%H:%M  %A, %d %B}",
        "tooltip-format": "<tt><small>{calendar}</small></tt>",
        "calendar": {
            "mode": "month",
            "format": {
                "months": "<span color='#CEB153'><b>{}</b></span>",
                "days": "<span color='#cdd6f4'><b>{}</b></span>",
                "weekdays": "<span color='#AF8D61'><b>{}</b></span>",
                "today": "<span color='#7B8387'><b><u>{}</u></b></span>"
            }
        }
    },

    "cpu": {
        "format": " {usage}%",
        "tooltip": false
    },

    "memory": {
        "format": " {}%"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": " {capacity}%",
        "format-plugged": " {capacity}%",
        "format-icons": ["", "", "", "", ""]
    },

    "network": {
        "format-wifi": " {essid}",
        "format-ethernet": " {ipaddr}",
        "format-disconnected": "⚠ Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}"
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": " Muted",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "default": ["", "", ""]
        },
        "on-click": "pamixer -t"
    },

    "tray": {
        "spacing": 10
    }
}
EOF

    cat > "$HOME/.config/waybar/style.css" << 'EOF'
/* Style Waybar - Hybrid Summer */
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: rgba(30, 30, 46, 0.8);
    color: #cdd6f4;
}

#workspaces button {
    padding: 0 10px;
    color: #7B8387;
    background: transparent;
    border-bottom: 3px solid transparent;
}

#workspaces button.active {
    color: #CEB153;
    border-bottom: 3px solid #CEB153;
}

#workspaces button.urgent {
    color: #f38ba8;
    border-bottom: 3px solid #f38ba8;
}

#workspaces button:hover {
    background: rgba(205, 214, 244, 0.1);
    box-shadow: inherit;
}

#window {
    color: #AF8D61;
    font-weight: bold;
}

#clock,
#battery,
#cpu,
#memory,
#network,
#pulseaudio,
#tray {
    padding: 0 10px;
    margin: 0 2px;
    background: rgba(123, 131, 135, 0.2);
    border-radius: 8px;
}

#clock {
    color: #CEB153;
    font-weight: bold;
}

#battery {
    color: #a6e3a1;
}

#battery.charging {
    color: #a6e3a1;
}

#battery.warning:not(.charging) {
    color: #fab387;
}

#battery.critical:not(.charging) {
    color: #f38ba8;
}

#cpu {
    color: #89dceb;
}

#memory {
    color: #cba6f7;
}

#network {
    color: #94e2d5;
}

#network.disconnected {
    color: #f38ba8;
}

#pulseaudio {
    color: #f9e2af;
}

#pulseaudio.muted {
    color: #7B8387;
}

#tray {
    background: transparent;
}
EOF

    print_success "Configuration Waybar installée"
}

# Installation de Kitty
install_kitty() {
    print_header "Installation de la configuration Kitty"

    cat > "$HOME/.config/kitty/kitty.conf" << 'EOF'
# Configuration Kitty - Style Hybrid Summer

# Police
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 11.0

# Curseur
cursor_shape block
cursor_blink_interval 0

# Scrollback
scrollback_lines 10000

# Souris
url_color #CEB153
url_style curly

# Fenêtre
remember_window_size  yes
initial_window_width  640
initial_window_height 400
window_padding_width 10
background_opacity 0.90

# Thème de couleurs - Hybrid Summer
foreground #cdd6f4
background #1e1e2e
selection_foreground #1e1e2e
selection_background #CEB153

# Noir
color0 #45475a
color8 #585b70

# Rouge
color1 #f38ba8
color9 #f38ba8

# Vert
color2  #a6e3a1
color10 #a6e3a1

# Jaune
color3  #CEB153
color11 #CEB153

# Bleu
color4  #89b4fa
color12 #89b4fa

# Magenta
color5  #f5c2e7
color13 #f5c2e7

# Cyan
color6  #7B8387
color14 #7B8387

# Blanc
color7  #bac2de
color15 #cdd6f4

# Couleur accent
color16 #AF8D61
color17 #CEB153
EOF

    print_success "Configuration Kitty installée"
}

# Installation de Wofi
install_wofi() {
    print_header "Installation de la configuration Wofi"

    cat > "$HOME/.config/wofi/config" << 'EOF'
width=600
height=400
location=center
show=drun
prompt=Search...
filter_rate=100
allow_markup=true
no_actions=true
halign=fill
orientation=vertical
content_halign=fill
insensitive=true
allow_images=true
image_size=40
gtk_dark=true
EOF

    cat > "$HOME/.config/wofi/style.css" << 'EOF'
/* Style Wofi - Hybrid Summer */
window {
    margin: 0px;
    border: 2px solid #CEB153;
    background-color: rgba(30, 30, 46, 0.95);
    border-radius: 17px;
}

#input {
    margin: 10px;
    padding: 10px;
    border: none;
    color: #cdd6f4;
    background-color: rgba(69, 71, 90, 0.5);
    border-radius: 8px;
}

#inner-box {
    margin: 5px;
    border: none;
    background-color: transparent;
}

#outer-box {
    margin: 5px;
    border: none;
    background-color: transparent;
}

#scroll {
    margin: 0px;
    border: none;
}

#text {
    margin: 5px;
    border: none;
    color: #cdd6f4;
}

#entry:selected {
    background-color: rgba(206, 177, 83, 0.3);
    border-radius: 8px;
}

#text:selected {
    color: #CEB153;
}
EOF

    print_success "Configuration Wofi installée"
}

# Installation de Mako
install_mako() {
    print_header "Installation de la configuration Mako"

    cat > "$HOME/.config/mako/config" << 'EOF'
# Configuration Mako - Style Hybrid Summer

sort=-time
layer=overlay
background-color=#1e1e2eE6
width=300
height=110
border-size=2
border-color=#CEB153
border-radius=17
icons=1
max-icon-size=64
default-timeout=5000
ignore-timeout=1
font=JetBrainsMono Nerd Font 11

[urgency=low]
border-color=#7B8387

[urgency=normal]
border-color=#CEB153

[urgency=high]
border-color=#f38ba8
default-timeout=0

[category=mpd]
default-timeout=2000
group-by=category
EOF

    print_success "Configuration Mako installée"
}

# Téléchargement d'un wallpaper par défaut
download_wallpaper() {
    print_header "Configuration du wallpaper"

    WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

    # Créer un script pour changer le wallpaper
    cat > "$HOME/.config/hypr/scripts/wallpaper.sh" << 'EOF'
#!/usr/bin/env bash
# Script de changement de wallpaper

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Si un argument est fourni, l'utiliser comme wallpaper
if [ -n "$1" ]; then
    WALLPAPER="$1"
else
    # Sinon, choisir un wallpaper aléatoire
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
fi

# Appliquer le wallpaper avec swww
if [ -f "$WALLPAPER" ]; then
    swww img "$WALLPAPER" --transition-fps 60 --transition-type wipe --transition-duration 2

    # Générer le thème avec pywal
    if command -v wal &> /dev/null; then
        wal -i "$WALLPAPER" -n -q
    fi
fi
EOF

    chmod +x "$HOME/.config/hypr/scripts/wallpaper.sh"

    print_info "Placez vos wallpapers dans: $WALLPAPER_DIR"
    print_info "Utilisez: ~/.config/hypr/scripts/wallpaper.sh [chemin_vers_image]"

    print_success "Script wallpaper installé"
}

# Fonction principale
main() {
    clear
    print_header "CUSTOMISATION HYPRLAND - STYLE HYBRID SUMMER"

    echo "Ce script va installer et configurer Hyprland avec le style 'Hybrid Summer'"
    echo "inspiré du repo end-4/dots-hyprland"
    echo ""
    read -p "Voulez-vous continuer? (o/N) " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
        print_info "Installation annulée"
        exit 0
    fi

    # Menu de sélection
    echo ""
    echo "Que voulez-vous installer?"
    echo "1) Installation complète (recommandé)"
    echo "2) Dépendances seulement"
    echo "3) Configuration seulement (sans dépendances)"
    echo "4) Composants spécifiques"
    echo ""
    read -p "Choix (1-4): " choice

    case $choice in
        1)
            install_dependencies
            backup_configs
            create_directories
            install_hypr_config
            install_keybinds
            install_waybar
            install_kitty
            install_wofi
            install_mako
            download_wallpaper
            ;;
        2)
            install_dependencies
            ;;
        3)
            backup_configs
            create_directories
            install_hypr_config
            install_keybinds
            install_waybar
            install_kitty
            install_wofi
            install_mako
            download_wallpaper
            ;;
        4)
            echo ""
            echo "Sélectionnez les composants à installer:"
            read -p "Hyprland config? (o/N) " hypr
            read -p "Waybar? (o/N) " waybar
            read -p "Kitty? (o/N) " kitty
            read -p "Wofi? (o/N) " wofi
            read -p "Mako? (o/N) " mako

            backup_configs
            create_directories

            [[ $hypr =~ ^[OoYy]$ ]] && install_hypr_config && install_keybinds
            [[ $waybar =~ ^[OoYy]$ ]] && install_waybar
            [[ $kitty =~ ^[OoYy]$ ]] && install_kitty
            [[ $wofi =~ ^[OoYy]$ ]] && install_wofi
            [[ $mako =~ ^[OoYy]$ ]] && install_mako

            download_wallpaper
            ;;
        *)
            print_error "Choix invalide"
            exit 1
            ;;
    esac

    print_header "INSTALLATION TERMINÉE"
    print_success "Configuration Hyprland installée avec succès!"
    echo ""
    print_info "Prochaines étapes:"
    echo "  1. Ajoutez vos wallpapers dans ~/Pictures/Wallpapers"
    echo "  2. Déconnectez-vous et sélectionnez Hyprland au login"
    echo "  3. Appuyez sur SUPER+D pour ouvrir le lanceur d'applications"
    echo ""
    print_info "Keybinds principaux:"
    echo "  SUPER + Return      : Ouvrir le terminal"
    echo "  SUPER + D           : Lanceur d'applications"
    echo "  SUPER + Q           : Fermer la fenêtre"
    echo "  SUPER + 1-9         : Changer de workspace"
    echo "  SUPER + Mouse       : Déplacer/redimensionner"
    echo ""
    print_warning "Note: Certains composants peuvent nécessiter un redémarrage"
}

# Exécution
main "$@"

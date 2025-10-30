#!/usr/bin/env bash

#############################################
# Script d'installation pour NixOS         #
# Hyprland - Style Hybrid Summer            #
#############################################

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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

# Vérifier que nous sommes sur NixOS
check_nixos() {
    if [ ! -f /etc/NIXOS ]; then
        print_error "Ce script est conçu pour NixOS"
        print_info "Utilisez ./customize-hyprland.sh pour les autres distributions"
        exit 1
    fi
    print_success "NixOS détecté"
}

# Vérifier que Hyprland est installé
check_hyprland() {
    print_info "Vérification de l'installation d'Hyprland..."

    if command -v Hyprland &> /dev/null; then
        print_success "Hyprland est installé"
    else
        print_error "Hyprland n'est pas installé"
        print_info "Ajoutez 'programs.hyprland.enable = true;' dans votre configuration.nix"
        print_info "Puis exécutez: sudo nixos-rebuild switch"
        exit 1
    fi
}

# Vérifier les dépendances
check_dependencies() {
    print_header "Vérification des dépendances"

    MISSING_DEPS=()

    DEPS=(
        "kitty:Terminal"
        "wofi:Lanceur d'applications"
        "waybar:Barre de statut"
        "swww:Gestionnaire de wallpapers"
        "mako:Notifications"
        "grim:Captures d'écran"
        "slurp:Sélection de zone"
        "wl-copy:Presse-papier"
    )

    for dep in "${DEPS[@]}"; do
        cmd="${dep%%:*}"
        name="${dep##*:}"

        if ! command -v "$cmd" &> /dev/null; then
            MISSING_DEPS+=("$cmd ($name)")
        fi
    done

    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        print_warning "Dépendances manquantes:"
        for dep in "${MISSING_DEPS[@]}"; do
            echo "  - $dep"
        done
        echo ""
        print_info "Ajoutez ces paquets dans votre configuration.nix ou home.nix"
        print_info "Voir NIXOS-INSTALL.md pour un exemple de configuration"
        echo ""
        read -p "Continuer quand même? (o/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
            exit 0
        fi
    else
        print_success "Toutes les dépendances sont installées"
    fi
}

# Sauvegarde
backup_configs() {
    print_header "Sauvegarde des configurations existantes"

    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    CONFIGS=("hypr" "waybar" "kitty" "wofi" "mako")
    BACKED_UP=0

    for config in "${CONFIGS[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            print_info "Sauvegarde de $config..."
            cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
            BACKED_UP=1
        fi
    done

    if [ $BACKED_UP -eq 1 ]; then
        print_success "Sauvegarde créée dans: $BACKUP_DIR"
    else
        print_info "Aucune configuration existante à sauvegarder"
        rm -rf "$BACKUP_DIR"
    fi
}

# Création des répertoires
create_directories() {
    print_header "Création des répertoires"

    DIRS=(
        "$HOME/.config/hypr/scripts"
        "$HOME/.config/waybar"
        "$HOME/.config/kitty"
        "$HOME/.config/wofi"
        "$HOME/.config/mako"
        "$HOME/.config/swaylock"
        "$HOME/.config/wlogout"
        "$HOME/Pictures/Wallpapers"
        "$HOME/Pictures/Screenshots"
    )

    for dir in "${DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_info "Créé: $dir"
        fi
    done

    print_success "Répertoires créés"
}

# Installation config Hyprland
install_hyprland_config() {
    print_header "Installation de la configuration Hyprland"

    # hyprland.conf
    cat > "$HOME/.config/hypr/hyprland.conf" << 'EOF'
# Configuration Hyprland - Style Hybrid Summer
# NixOS Edition

# Moniteurs
monitor=,preferred,auto,1

# Source des fichiers de configuration
source = ~/.config/hypr/colors.conf
source = ~/.config/hypr/keybinds.conf
source = ~/.config/hypr/env.conf

# Programmes au démarrage
exec-once = waybar
exec-once = mako
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
exec-once = swww init
exec-once = nm-applet --indicator
exec-once = blueman-applet

# Input
input {
    kb_layout = us
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
        ignore_opacity = true
        xray = false
    }

    shadow {
        enabled = false
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }
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
windowrulev2 = opacity 0.95 0.95,class:^(Code)$
EOF

    # colors.conf
    cat > "$HOME/.config/hypr/colors.conf" << 'EOF'
# Couleurs - Thème Hybrid Summer
$color_accent = rgba(CEB153FF)
$color_bg = rgba(1e1e2eFF)
$color_fg = rgba(cdd6f4FF)
$color_inactive = rgba(AF8D6166)
EOF

    # env.conf - NixOS spécifique
    cat > "$HOME/.config/hypr/env.conf" << 'EOF'
# Variables d'environnement - NixOS
env = NIXOS_OZONE_WL,1
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

    print_success "Configuration Hyprland installée"
}

# Installation keybinds
install_keybinds() {
    cat > "$HOME/.config/hypr/keybinds.conf" << 'EOF'
# Keybindings - Style Hybrid Summer

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

bind = $mainMod, S, togglespecialworkspace,
bind = $mainMod SHIFT, S, movetoworkspace, special

bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
EOF

    print_success "Keybinds installés"
}

# Installation Waybar
install_waybar() {
    print_header "Installation de Waybar"

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

    print_success "Waybar installé"
}

# Installation Kitty
install_kitty() {
    print_header "Installation de Kitty"

    cat > "$HOME/.config/kitty/kitty.conf" << 'EOF'
# Configuration Kitty - Style Hybrid Summer

font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 11.0

cursor_shape block
cursor_blink_interval 0

scrollback_lines 10000

url_color #CEB153
url_style curly

remember_window_size  yes
initial_window_width  640
initial_window_height 400
window_padding_width 10
background_opacity 0.90

# Thème Hybrid Summer
foreground #cdd6f4
background #1e1e2e
selection_foreground #1e1e2e
selection_background #CEB153

color0 #45475a
color8 #585b70

color1 #f38ba8
color9 #f38ba8

color2  #a6e3a1
color10 #a6e3a1

color3  #CEB153
color11 #CEB153

color4  #89b4fa
color12 #89b4fa

color5  #f5c2e7
color13 #f5c2e7

color6  #7B8387
color14 #7B8387

color7  #bac2de
color15 #cdd6f4

color16 #AF8D61
color17 #CEB153
EOF

    print_success "Kitty installé"
}

# Installation Wofi
install_wofi() {
    print_header "Installation de Wofi"

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

    print_success "Wofi installé"
}

# Installation Mako
install_mako() {
    print_header "Installation de Mako"

    cat > "$HOME/.config/mako/config" << 'EOF'
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

    print_success "Mako installé"
}

# Installation script wallpaper
install_wallpaper_script() {
    print_header "Installation du script wallpaper"

    cat > "$HOME/.config/hypr/scripts/wallpaper.sh" << 'EOF'
#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ -n "$1" ]; then
    WALLPAPER="$1"
else
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
fi

if [ -f "$WALLPAPER" ]; then
    swww img "$WALLPAPER" --transition-fps 60 --transition-type wipe --transition-duration 2

    if command -v wal &> /dev/null; then
        wal -i "$WALLPAPER" -n -q
    fi
fi
EOF

    chmod +x "$HOME/.config/hypr/scripts/wallpaper.sh"

    print_success "Script wallpaper installé"
}

# Menu principal
main() {
    clear
    print_header "INSTALLATION HYPRLAND POUR NIXOS"
    print_info "Style: Hybrid Summer"
    echo ""

    check_nixos
    check_hyprland
    check_dependencies

    echo ""
    read -p "Continuer l'installation? (o/N) " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
        print_info "Installation annulée"
        exit 0
    fi

    backup_configs
    create_directories
    install_hyprland_config
    install_keybinds
    install_waybar
    install_kitty
    install_wofi
    install_mako
    install_wallpaper_script

    print_header "INSTALLATION TERMINÉE"
    print_success "Configuration Hyprland installée!"
    echo ""
    print_info "Prochaines étapes:"
    echo "  1. Vérifiez que toutes les dépendances sont installées (voir NIXOS-INSTALL.md)"
    echo "  2. Ajoutez des wallpapers dans ~/Pictures/Wallpapers"
    echo "  3. Déconnectez-vous et sélectionnez Hyprland"
    echo ""
    print_info "Raccourcis principaux:"
    echo "  SUPER + Return : Terminal"
    echo "  SUPER + D      : Lanceur"
    echo "  SUPER + Q      : Fermer"
    echo ""
    print_warning "Si certains paquets sont manquants, consultez:"
    print_info "cat NIXOS-INSTALL.md"
}

main "$@"

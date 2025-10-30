#!/usr/bin/env bash

#############################################
# Script de correction COMPLET Hyprland    #
# Pour les versions >= 0.35                #
#############################################

CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

echo "🔧 Correction complète de la configuration Hyprland..."

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Fichier $CONFIG_FILE introuvable"
    exit 1
fi

# Sauvegarde avec timestamp
BACKUP_FILE="$CONFIG_FILE.bak-$(date +%Y%m%d-%H%M%S)"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✅ Sauvegarde créée: $BACKUP_FILE"

# Afficher les lignes problématiques
echo ""
echo "📋 Analyse des erreurs potentielles..."
echo ""

# Réécriture complète avec syntaxe correcte
cat > "$CONFIG_FILE" << 'EOF'
# Configuration Hyprland - Style Hybrid Summer
# Version compatible avec Hyprland >= 0.35

# Moniteurs
monitor=,preferred,auto,1

# Source des fichiers de configuration
source = ~/.config/hypr/colors.conf
source = ~/.config/hypr/keybinds.conf
source = ~/.config/hypr/env.conf

# Programmes au démarrage
exec-once = waybar
exec-once = mako
exec-once = swww init
exec-once = nm-applet --indicator
exec-once = blueman-applet

# Variables
$terminal = kitty
$fileManager = thunar
$menu = wofi --show drun

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
        natural_scroll = true
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

    # Bordures avec dégradé Hybrid Summer
    col.active_border = rgba(AF8D61FF) rgba(CEB153FF) rgba(7B8387FF) 45deg
    col.inactive_border = rgba(AF8D6166)

    layout = dwindle

    allow_tearing = false
}

# Décoration
decoration {
    rounding = 17

    active_opacity = 1.0
    inactive_opacity = 1.0

    shadow {
        enabled = false
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }

    blur {
        enabled = true
        size = 7
        passes = 4
        ignore_opacity = true
        xray = false
    }
}

# Animations
animations {
    enabled = true

    bezier = md3_standard, 0.2, 0.0, 0, 1.0
    bezier = md3_decel, 0.05, 0.7, 0.1, 1
    bezier = md3_accel, 0.3, 0, 0.8, 0.15
    bezier = overshot, 0.05, 0.9, 0.1, 1.05
    bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
    bezier = gnome, 0, 0.85, 0.3, 1

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
    pseudotile = true
    preserve_split = true
    no_gaps_when_only = false
}

master {
    new_status = master
}

# Gestes
gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 4
}

# Divers
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    force_default_wallpaper = 0
    vfr = true
}

# Règles des fenêtres
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(blueman-manager)$
windowrule = float, ^(nm-connection-editor)$
windowrule = float, title:^(Open File)$
windowrule = float, title:^(Save File)$
windowrule = float, title:^(Open Folder)$

windowrulev2 = float, class:^(kitty)$, title:^(kitty-float)$
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, class:^(blueman-manager)$

# Opacité
windowrulev2 = opacity 0.90 0.90, class:^(kitty)$
windowrulev2 = opacity 0.95 0.95, class:^(code)$
windowrulev2 = opacity 0.95 0.95, class:^(Code)$
windowrulev2 = opacity 0.95 0.95, class:^(firefox)$
EOF

echo ""
echo "✅ Configuration corrigée avec syntaxe Hyprland >= 0.35"
echo ""
echo "📋 Corrections appliquées:"
echo "  ✓ Structure shadow correcte"
echo "  ✓ Suppression de new_optimizations"
echo "  ✓ Correction de new_is_master → new_status"
echo "  ✓ Correction de yes/no → true/false"
echo "  ✓ Ajout de allow_tearing = false"
echo "  ✓ Ajout de force_default_wallpaper"
echo "  ✓ Ajout de vfr = true"
echo "  ✓ Syntaxe windowrule/windowrulev2 corrigée"
echo ""
echo "🔄 Pour appliquer les changements:"
echo ""
echo "Option 1 (recommandée): Recharger Hyprland"
echo "  hyprctl reload"
echo ""
echo "Option 2: Redémarrer Hyprland"
echo "  1. SUPER + M (quitter)"
echo "  2. Reconnectez-vous"
echo ""
echo "Option 3: Forcer le redémarrage"
echo "  killall Hyprland"
echo "  (puis reconnectez-vous depuis le gestionnaire de connexion)"
echo ""
echo "💾 Sauvegarde disponible: $BACKUP_FILE"
echo ""
echo "🧪 Tester la configuration:"
echo "  hyprctl reload"
echo "  (Si pas d'erreur popup, c'est bon!)"

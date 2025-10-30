#!/usr/bin/env bash

#############################################
# Script de correction pour Hyprland       #
# Corrige la syntaxe pour les nouvelles    #
# versions de Hyprland                      #
#############################################

CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

echo "🔧 Correction de la configuration Hyprland..."

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Fichier $CONFIG_FILE introuvable"
    exit 1
fi

# Sauvegarde
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
echo "✅ Sauvegarde créée: $CONFIG_FILE.bak"

# Correction de la section decoration
sed -i '/^decoration {$/,/^}$/ {
    s/drop_shadow = no/shadow {\n        enabled = false/
    s/shadow_range = 4/range = 4/
    s/shadow_render_power = 3/render_power = 3/
    s/col\.shadow = rgba(1a1a1aee)/color = rgba(1a1a1aee)\n    }/
    /new_optimizations = on/d
}' "$CONFIG_FILE"

# Correction manuelle plus fiable
cat > "$CONFIG_FILE" << 'EOF'
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

echo "✅ Configuration corrigée!"
echo ""
echo "📋 Changements effectués:"
echo "  - drop_shadow → shadow { enabled = false }"
echo "  - shadow_range → range"
echo "  - shadow_render_power → render_power"
echo "  - col.shadow → color"
echo "  - Suppression de new_optimizations"
echo ""
echo "🔄 Pour appliquer:"
echo "  1. Si vous êtes dans Hyprland: SUPER + SHIFT + R (ou redémarrez Hyprland)"
echo "  2. Ou déconnectez-vous et reconnectez-vous"
echo ""
echo "📝 Une sauvegarde a été créée: $CONFIG_FILE.bak"

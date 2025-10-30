#!/usr/bin/env bash

echo "🔧 Application de la correction Hyprland..."
echo ""

CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"
FIXED_FILE="$(dirname "$0")/hyprland.conf.fixed"

# Sauvegarde
BACKUP_FILE="$CONFIG_FILE.backup-$(date +%Y%m%d-%H%M%S)"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✅ Sauvegarde créée: $BACKUP_FILE"

# Copier le fichier corrigé
cp "$FIXED_FILE" "$CONFIG_FILE"

echo "✅ Configuration corrigée appliquée!"
echo ""
echo "📋 Corrections effectuées:"
echo "  Ligne 29:  natural_scroll = yes → true"
echo "  Ligne 72:  enabled = yes → true"
echo "  Ligne 77:  Suppression de win10 et funky bezier"
echo "  Ligne 94:  pseudotile = yes → true"
echo "  Ligne 95:  preserve_split = yes → true"
echo "  Ligne 99:  new_is_master = true → new_status = master"
echo "  Ligne 104: workspace_swipe = on → true"
echo "  Ligne 113: vrr = 0 → vfr = true"
echo "  Ligne 114: Ajout de force_default_wallpaper = 0"
echo ""
echo "🔄 Pour appliquer immédiatement:"
echo ""
echo "  hyprctl reload"
echo ""
echo "Ou redémarrez Hyprland (SUPER + M puis reconnectez-vous)"
echo ""

# Hyprland Customization Script - Style Hybrid Summer

Script de customisation complet pour Hyprland inspiré du thème "Hybrid Summer" du repo [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland/tree/archive/hybrid-summer).

## Aperçu

Ce script automatise l'installation et la configuration d'un environnement Hyprland élégant avec :

- **Thème de couleurs chaud** : Palette beige/doré/gris inspirée de l'été
- **Animations fluides** : Courbes Material Design 3 et effets personnalisés
- **Interface moderne** : Bordures arrondies (17px), flou gaussien, transparence
- **Configuration complète** : Waybar, Kitty, Wofi, Mako pré-configurés

## Palette de Couleurs

Le thème "Hybrid Summer" utilise une palette chaleureuse et élégante :

- **Accent principal** : `#CEB153` (Jaune doré)
- **Accent secondaire** : `#AF8D61` (Beige/Brun)
- **Accent tertiaire** : `#7B8387` (Gris bleuté)
- **Background** : `#1e1e2e` (Noir doux)
- **Foreground** : `#cdd6f4` (Blanc cassé)

## Captures d'écran

Le style inclut :
- Bordures avec dégradé coloré sur les fenêtres actives
- Barre supérieure (Waybar) semi-transparente avec icônes élégantes
- Terminal (Kitty) avec fond transparent et couleurs harmonieuses
- Lanceur d'applications (Wofi) avec design moderne et arrondi
- Notifications (Mako) avec bordures colorées selon l'urgence

## Prérequis

- Système Linux (Arch, Ubuntu, Debian, Fedora)
- Accès sudo pour l'installation des paquets
- Connexion Internet

## Installation

### Installation rapide (recommandée)

```bash
# Cloner ce repository
git clone https://github.com/roroNFT/dot-hyprland.git
cd dot-hyprland

# Rendre le script exécutable
chmod +x customize-hyprland.sh

# Lancer le script
./customize-hyprland.sh
```

### Options d'installation

Le script propose plusieurs modes d'installation :

1. **Installation complète** : Dépendances + Configuration (recommandé pour nouveau setup)
2. **Dépendances seulement** : Installe uniquement les paquets nécessaires
3. **Configuration seulement** : Applique la configuration sans installer les dépendances
4. **Composants spécifiques** : Choisir individuellement les composants à installer

## Composants installés

### Applications principales

- **Hyprland** : Gestionnaire de fenêtres Wayland
- **Waybar** : Barre de statut personnalisable
- **Kitty** : Terminal moderne et rapide
- **Wofi** : Lanceur d'applications
- **Mako** : Système de notifications
- **swww** : Gestionnaire de wallpapers avec transitions

### Utilitaires

- **grim + slurp** : Captures d'écran
- **wl-clipboard** : Presse-papiers Wayland
- **brightnessctl** : Contrôle de luminosité
- **pamixer** : Contrôle audio
- **playerctl** : Contrôle de lecture média
- **Network Manager** : Gestion réseau
- **Blueman** : Gestion Bluetooth

### Polices

- **JetBrains Mono Nerd Font** : Police principale
- **Font Awesome** : Icônes
- **Noto Emoji** : Emojis

## Configuration

### Fichiers de configuration créés

```
~/.config/
├── hypr/
│   ├── hyprland.conf      # Configuration principale
│   ├── colors.conf        # Définition des couleurs
│   ├── keybinds.conf      # Raccourcis clavier
│   ├── env.conf           # Variables d'environnement
│   └── scripts/
│       └── wallpaper.sh   # Script de gestion des wallpapers
├── waybar/
│   ├── config             # Configuration Waybar
│   └── style.css          # Style Waybar
├── kitty/
│   └── kitty.conf         # Configuration Kitty
├── wofi/
│   ├── config             # Configuration Wofi
│   └── style.css          # Style Wofi
└── mako/
    └── config             # Configuration Mako
```

### Sauvegarde automatique

Le script crée automatiquement une sauvegarde de vos configurations existantes dans :
```
~/.config-backup-YYYYMMDD-HHMMSS/
```

## Raccourcis clavier

### Essentiels

| Raccourci | Action |
|-----------|--------|
| `SUPER + Return` | Ouvrir le terminal (Kitty) |
| `SUPER + D` | Lanceur d'applications (Wofi) |
| `SUPER + Q` | Fermer la fenêtre active |
| `SUPER + M` | Quitter Hyprland |
| `SUPER + F` | Mode plein écran |
| `SUPER + V` | Basculer flottant/tiling |

### Navigation

| Raccourci | Action |
|-----------|--------|
| `SUPER + ↑↓←→` | Naviguer entre les fenêtres |
| `SUPER + h/j/k/l` | Naviguer (style Vim) |
| `SUPER + 1-9` | Aller au workspace 1-9 |
| `SUPER + Mouse Scroll` | Changer de workspace |

### Gestion des fenêtres

| Raccourci | Action |
|-----------|--------|
| `SUPER + SHIFT + ↑↓←→` | Déplacer la fenêtre |
| `SUPER + CTRL + ↑↓←→` | Redimensionner la fenêtre |
| `SUPER + SHIFT + 1-9` | Déplacer vers workspace 1-9 |
| `SUPER + Mouse Gauche` | Déplacer la fenêtre |
| `SUPER + Mouse Droit` | Redimensionner la fenêtre |

### Médias et système

| Raccourci | Action |
|-----------|--------|
| `Print` | Capture d'écran (zone) |
| `SHIFT + Print` | Capture d'écran (écran complet) |
| `SUPER + Print` | Capture dans ~/Pictures/Screenshots |
| `XF86AudioRaiseVolume` | Augmenter le volume |
| `XF86AudioLowerVolume` | Diminuer le volume |
| `XF86AudioMute` | Couper/activer le son |
| `XF86MonBrightnessUp` | Augmenter la luminosité |
| `XF86MonBrightnessDown` | Diminuer la luminosité |
| `XF86AudioPlay` | Lecture/Pause |
| `XF86AudioNext/Prev` | Piste suivante/précédente |

## Personnalisation

### Changer les couleurs

Éditez `~/.config/hypr/colors.conf` pour modifier la palette :

```conf
$color_accent = rgba(CEB153FF)     # Couleur principale
$color_bg = rgba(1e1e2eFF)         # Fond
$color_fg = rgba(cdd6f4FF)         # Texte
$color_inactive = rgba(AF8D6166)   # Éléments inactifs
```

### Ajouter des wallpapers

1. Placez vos images dans `~/Pictures/Wallpapers/`
2. Utilisez le script pour changer de wallpaper :

```bash
~/.config/hypr/scripts/wallpaper.sh
# ou avec une image spécifique :
~/.config/hypr/scripts/wallpaper.sh ~/Pictures/Wallpapers/mon-image.jpg
```

### Modifier les animations

Éditez `~/.config/hypr/hyprland.conf` section `animations` pour ajuster :
- Les courbes de Bézier
- La durée des animations
- Les effets de transition

### Personnaliser Waybar

Éditez les fichiers dans `~/.config/waybar/` :
- `config` : Modules et disposition
- `style.css` : Apparence et couleurs

## Dépannage

### Hyprland ne démarre pas

1. Vérifiez les logs : `journalctl -xe`
2. Vérifiez que les drivers GPU sont installés
3. Essayez de démarrer Hyprland depuis un TTY : `Hyprland`

### Les polices ne s'affichent pas correctement

```bash
# Mettre à jour le cache des polices
fc-cache -fv
```

### Waybar ne s'affiche pas

```bash
# Relancer Waybar
killall waybar && waybar &
```

### Les captures d'écran ne fonctionnent pas

```bash
# Vérifier que grim et slurp sont installés
which grim slurp
```

### Problèmes de performance

Réduisez les effets dans `~/.config/hypr/hyprland.conf` :
- Diminuez `blur.passes` (de 4 à 2)
- Désactivez `blur.enabled = false`
- Réduisez l'arrondi : `rounding = 10`

## Désinstallation

Pour revenir à votre configuration précédente :

```bash
# Restaurer depuis la sauvegarde
cp -r ~/.config-backup-*/hypr ~/.config/
cp -r ~/.config-backup-*/waybar ~/.config/
# etc.
```

Ou supprimer complètement :

```bash
rm -rf ~/.config/hypr
rm -rf ~/.config/waybar
rm -rf ~/.config/kitty
rm -rf ~/.config/wofi
rm -rf ~/.config/mako
```

## Distributions supportées

- ✅ Arch Linux / Manjaro / EndeavourOS (recommandé)
- ✅ Fedora
- ⚠️ Ubuntu / Debian (Hyprland doit être installé manuellement)
- ⚠️ Pop!_OS (Hyprland doit être installé manuellement)

## Crédits

- Thème inspiré de [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
- Palette de couleurs basée sur "Hybrid Summer"
- Configuration optimisée pour une expérience moderne et fluide

## Licence

MIT License - Libre d'utilisation, modification et distribution

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Ouvrir une issue pour signaler un bug
- Proposer des améliorations
- Soumettre une pull request

## Ressources

- [Documentation Hyprland](https://wiki.hyprland.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [r/unixporn](https://reddit.com/r/unixporn) pour l'inspiration

## Support

Pour toute question ou problème :
- Ouvrez une issue sur GitHub
- Consultez la documentation Hyprland
- Rejoignez la communauté Hyprland sur Discord

---

**Profitez de votre nouvel environnement Hyprland !** ☀️

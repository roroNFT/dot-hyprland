# Installation sur NixOS - Hyprland Hybrid Summer

Guide complet pour installer la configuration Hyprland style Hybrid Summer sur NixOS.

## Table des matières

1. [Prérequis](#prérequis)
2. [Installation des dépendances](#installation-des-dépendances)
3. [Installation de la configuration](#installation-de-la-configuration)
4. [Configuration NixOS](#configuration-nixos)
5. [Utilisation](#utilisation)
6. [Dépannage](#dépannage)

## Prérequis

- NixOS installé
- Hyprland déjà installé
- Accès à votre `configuration.nix`
- Git installé

## Installation des dépendances

### Option 1 : Configuration déclarative (Recommandé)

Ajoutez les paquets nécessaires dans votre `/etc/nixos/configuration.nix` :

```nix
{ config, pkgs, ... }:

{
  # ... votre configuration existante ...

  # Activer Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Paquets pour l'environnement Hyprland
  environment.systemPackages = with pkgs; [
    # Terminal
    kitty

    # Lanceur d'applications
    wofi

    # Barre de statut
    waybar

    # Gestionnaire de wallpapers
    swww

    # Notifications
    mako
    libnotify

    # Captures d'écran
    grim
    slurp
    wl-clipboard

    # Contrôle système
    brightnessctl
    pamixer
    playerctl

    # Gestionnaires réseau et Bluetooth
    networkmanagerapplet
    blueman

    # Polices
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
    noto-fonts-emoji

    # Utilitaires
    polkit_gnome
    xdg-desktop-portal-hyprland
    qt5.qtwayland
    qt6.qtwayland
    imagemagick
    jq

    # Pywal pour les thèmes (optionnel)
    pywal
  ];

  # Polices système
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
    noto-fonts-emoji
  ];

  # Services nécessaires
  services = {
    # Gestionnaire de polices
    gnome.gnome-keyring.enable = true;

    # Support Bluetooth
    blueman.enable = true;
  };

  # XDG portals pour Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Polkit pour les permissions
  security.polkit.enable = true;
}
```

Puis reconstruisez votre système :

```bash
sudo nixos-rebuild switch
```

### Option 2 : Installation utilisateur avec Home Manager

Si vous utilisez Home Manager, ajoutez dans votre `home.nix` :

```nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    wofi
    waybar
    swww
    mako
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
    playerctl
    networkmanagerapplet
    blueman
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
    imagemagick
    jq
    pywal
  ];

  # Configuration Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
  };
}
```

Puis :

```bash
home-manager switch
```

## Installation de la configuration

### Méthode automatique (Recommandée)

Utilisez le script d'installation pour NixOS :

```bash
# Cloner le repo si ce n'est pas déjà fait
cd ~
git clone https://github.com/roroNFT/dot-hyprland.git
cd dot-hyprland

# Lancer le script d'installation pour NixOS
./install-nixos.sh
```

Le script va :
1. Sauvegarder vos configurations existantes
2. Créer tous les répertoires nécessaires
3. Installer les fichiers de configuration Hyprland
4. Configurer Waybar, Kitty, Wofi et Mako
5. Créer les scripts utilitaires

### Méthode manuelle

Si vous préférez installer manuellement :

```bash
# 1. Sauvegarde de votre config existante
mkdir -p ~/.config-backup-$(date +%Y%m%d)
cp -r ~/.config/hypr ~/.config-backup-$(date +%Y%m%d)/ 2>/dev/null || true

# 2. Créer les répertoires
mkdir -p ~/.config/hypr/{scripts,}
mkdir -p ~/.config/{waybar,kitty,wofi,mako,swaylock,wlogout}
mkdir -p ~/Pictures/Wallpapers

# 3. Copier les configurations
# Vous devrez créer les fichiers de configuration manuellement
# ou utiliser le script d'installation
```

## Configuration NixOS

### Structure des fichiers

Après l'installation, vous aurez :

```
~/.config/
├── hypr/
│   ├── hyprland.conf      # Configuration principale
│   ├── colors.conf        # Couleurs du thème
│   ├── keybinds.conf      # Raccourcis clavier
│   ├── env.conf           # Variables d'environnement
│   └── scripts/
│       └── wallpaper.sh   # Gestion des wallpapers
├── waybar/
│   ├── config             # Config Waybar
│   └── style.css          # Style Waybar
├── kitty/
│   └── kitty.conf         # Config Kitty
├── wofi/
│   ├── config             # Config Wofi
│   └── style.css          # Style Wofi
└── mako/
    └── config             # Config Mako
```

### Démarrage automatique de Hyprland

Pour démarrer Hyprland automatiquement au login, ajoutez dans votre `configuration.nix` :

```nix
services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "votre-nom-utilisateur";
    };
  };
};

# Alternative : utiliser SDDM
# services.xserver = {
#   enable = true;
#   displayManager.sddm = {
#     enable = true;
#     wayland.enable = true;
#   };
# };
```

### Variables d'environnement spécifiques NixOS

NixOS nécessite parfois des ajustements. Dans `~/.config/hypr/env.conf`, vérifiez que vous avez :

```conf
# Variables d'environnement pour NixOS
env = NIXOS_OZONE_WL,1
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_QPA_PLATFORM,wayland
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = GDK_BACKEND,wayland,x11
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland
env = XCURSOR_SIZE,24
```

## Utilisation

### Premier lancement

1. **Déconnectez-vous** de votre session actuelle
2. **Sélectionnez Hyprland** dans votre gestionnaire de connexion
3. **Connectez-vous**

Au premier lancement :
- Waybar devrait s'afficher en haut
- Utilisez `SUPER + Return` pour ouvrir le terminal
- Utilisez `SUPER + D` pour le lanceur d'applications

### Ajouter des wallpapers

```bash
# Placer vos images dans
~/Pictures/Wallpapers/

# Lancer le script de wallpaper
~/.config/hypr/scripts/wallpaper.sh

# Ou spécifier une image
~/.config/hypr/scripts/wallpaper.sh ~/Pictures/Wallpapers/mon-image.jpg
```

### Raccourcis clavier essentiels

| Raccourci | Action |
|-----------|--------|
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + D` | Lanceur (Wofi) |
| `SUPER + Q` | Fermer fenêtre |
| `SUPER + M` | Quitter Hyprland |
| `SUPER + F` | Plein écran |
| `SUPER + 1-9` | Changer de workspace |
| `Print` | Screenshot (zone) |

Voir [README.md](README.md) pour la liste complète.

## Dépannage

### Hyprland ne démarre pas

```bash
# Vérifier les logs
journalctl -xe | grep -i hyprland

# Tester depuis un TTY
Hyprland
```

### Les applications ne se lancent pas

Sur NixOS, certaines applications peuvent nécessiter d'être dans votre PATH. Vérifiez dans `~/.config/hypr/hyprland.conf` que les chemins sont corrects.

Vous pouvez utiliser `which <commande>` pour trouver le chemin exact :

```bash
which kitty
which waybar
which wofi
```

Si nécessaire, utilisez les chemins complets dans la config.

### Les polices ne s'affichent pas

```bash
# Reconstruire le cache des polices
fc-cache -fv

# Vérifier que les polices sont installées
fc-list | grep -i jetbrains
```

### Waybar ne démarre pas

```bash
# Relancer Waybar manuellement
killall waybar
waybar &

# Vérifier les logs
waybar -l debug
```

### Problèmes avec SWWW (wallpapers)

```bash
# Initialiser SWWW
swww init

# Puis charger un wallpaper
swww img ~/Pictures/Wallpapers/votre-image.jpg
```

### Variables d'environnement non prises en compte

Sur NixOS, vous pouvez aussi définir les variables dans votre `configuration.nix` :

```nix
environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  QT_QPA_PLATFORM = "wayland";
  GDK_BACKEND = "wayland,x11";
};
```

### Home Manager conflict

Si vous utilisez Home Manager ET le fichier de config manuel, il peut y avoir des conflits. Choisissez une seule méthode :

**Option A** : Tout via Home Manager (déclaratif)
**Option B** : Config manuelle dans `~/.config/` (impératif)

## Configuration avec Home Manager (Avancé)

Pour une approche complètement déclarative, vous pouvez gérer toute la configuration via Home Manager :

```nix
# ~/.config/home-manager/home.nix ou ~/.config/nixpkgs/home.nix

{ config, pkgs, ... }:

{
  # Fichiers de configuration
  home.file = {
    ".config/hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
    ".config/hypr/colors.conf".source = ./dotfiles/hypr/colors.conf;
    ".config/hypr/keybinds.conf".source = ./dotfiles/hypr/keybinds.conf;
    ".config/hypr/env.conf".source = ./dotfiles/hypr/env.conf;
    ".config/waybar/config".source = ./dotfiles/waybar/config;
    ".config/waybar/style.css".source = ./dotfiles/waybar/style.css;
    ".config/kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
    ".config/wofi/config".source = ./dotfiles/wofi/config;
    ".config/wofi/style.css".source = ./dotfiles/wofi/style.css;
    ".config/mako/config".source = ./dotfiles/mako/config;
  };

  # Scripts
  home.file.".config/hypr/scripts/wallpaper.sh" = {
    source = ./dotfiles/hypr/scripts/wallpaper.sh;
    executable = true;
  };
}
```

Créez un dossier `dotfiles` dans le même répertoire que votre `home.nix` et placez-y vos fichiers de config.

## Mise à jour

Pour mettre à jour la configuration :

```bash
cd ~/dot-hyprland
git pull
./install-nixos.sh
```

Ou si vous utilisez Home Manager :

```bash
# Mettez à jour vos fichiers dans ~/dotfiles
home-manager switch
```

## Ressources NixOS

- [NixOS Wiki - Hyprland](https://nixos.wiki/wiki/Hyprland)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)

## Support

Pour les problèmes spécifiques à NixOS :
- Vérifiez la [NixOS Wiki](https://nixos.wiki/)
- Consultez le [Discourse NixOS](https://discourse.nixos.org/)
- Channel IRC : `#nixos` sur Libera.Chat

---

**Profitez de Hyprland sur NixOS !** ❄️

# Configuration NixOS pour Hyprland - Style Hybrid Summer
#
# Ce fichier peut être importé dans votre configuration.nix
# ou utilisé comme référence pour configurer les paquets nécessaires
#
# Usage:
#   1. Copiez ce fichier dans /etc/nixos/
#   2. Dans votre configuration.nix, ajoutez:
#      imports = [ ./hyprland-config.nix ];
#   3. Rebuild: sudo nixos-rebuild switch

{ config, pkgs, ... }:

{
  # Activer Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Paquets nécessaires pour l'environnement Hyprland Hybrid Summer
  environment.systemPackages = with pkgs; [
    # ===== Composants principaux =====

    # Terminal
    kitty

    # Lanceur d'applications
    wofi

    # Barre de statut
    waybar

    # Gestionnaire de wallpapers
    swww

    # Système de notifications
    mako
    libnotify

    # ===== Utilitaires Wayland =====

    # Captures d'écran
    grim          # Screenshot tool
    slurp         # Sélection de zone
    wl-clipboard  # Presse-papier Wayland

    # ===== Contrôle système =====

    # Audio
    pamixer       # Contrôle du volume
    pavucontrol   # Interface graphique audio

    # Luminosité
    brightnessctl # Contrôle de la luminosité

    # Média
    playerctl     # Contrôle de lecture média

    # ===== Gestionnaires réseau et Bluetooth =====

    networkmanagerapplet  # Applet NetworkManager
    blueman              # Gestionnaire Bluetooth

    # ===== Polices =====

    # Police principale
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # Icônes
    font-awesome

    # Emojis
    noto-fonts-emoji

    # ===== Sécurité et portails =====

    # Polkit
    polkit_gnome

    # XDG portals
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # ===== Support Qt et GTK =====

    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct

    # ===== Utilitaires additionnels =====

    imagemagick  # Manipulation d'images
    jq           # Parser JSON
    pywal        # Générateur de thèmes (optionnel)

    # ===== Gestionnaire de fichiers (optionnel) =====

    # thunar       # Gestionnaire de fichiers léger
    # xfce.thunar  # Alternative

    # ===== Outils de verrouillage (optionnel) =====

    # swaylock-effects  # Écran de verrouillage
    # wlogout          # Menu de déconnexion
  ];

  # Configuration des polices
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
      font-awesome
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Services
  services = {
    # Gestionnaire de clés GNOME
    gnome.gnome-keyring.enable = true;

    # Support Bluetooth
    blueman.enable = true;
  };

  # Polkit pour l'authentification graphique
  security.polkit.enable = true;

  # Variables d'environnement système
  environment.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";

    # XDG
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # Qt
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # GTK
    GDK_BACKEND = "wayland,x11";

    # SDL
    SDL_VIDEODRIVER = "wayland";

    # Clutter
    CLUTTER_BACKEND = "wayland";

    # Curseur
    XCURSOR_SIZE = "24";
  };

  # Configuration du gestionnaire de connexion (optionnel)
  #
  # Option 1: greetd avec tuigreet (minimal)
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  #       user = "greeter";
  #     };
  #   };
  # };

  # Option 2: SDDM (graphique)
  # services.xserver.enable = true;
  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };

  # Activer PipeWire pour l'audio (si pas déjà fait)
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   jack.enable = true;
  # };
}

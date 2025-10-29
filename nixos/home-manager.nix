# Configuration Home Manager pour Hyprland - Style Hybrid Summer
#
# Ce fichier configure Hyprland et ses dépendances via Home Manager
#
# Usage:
#   1. Assurez-vous que Home Manager est installé
#   2. Importez ce fichier dans votre home.nix:
#      imports = [ ./hyprland-home.nix ];
#   3. Rebuild: home-manager switch

{ config, pkgs, ... }:

{
  # Paquets pour Hyprland
  home.packages = with pkgs; [
    # Terminal
    kitty

    # Lanceur
    wofi

    # Barre de statut
    waybar

    # Wallpapers
    swww

    # Notifications
    mako
    libnotify

    # Screenshots
    grim
    slurp
    wl-clipboard

    # Contrôles
    brightnessctl
    pamixer
    playerctl

    # Réseau et Bluetooth
    networkmanagerapplet
    blueman

    # Polices
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome

    # Utilitaires
    imagemagick
    jq
    pywal
  ];

  # Configuration de Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    # Si vous voulez gérer la config via Nix (optionnel)
    # extraConfig = ''
    #   # Votre config Hyprland ici
    # '';
  };

  # Configuration de Waybar via Home Manager (optionnel)
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # La config sera dans ~/.config/waybar/ si vous utilisez les fichiers du repo
  };

  # Configuration de Kitty via Home Manager (optionnel)
  programs.kitty = {
    enable = true;
    # La config sera dans ~/.config/kitty/ si vous utilisez les fichiers du repo
  };

  # Configuration de Mako via Home Manager (optionnel)
  services.mako = {
    enable = true;
    # La config sera dans ~/.config/mako/ si vous utilisez les fichiers du repo
  };

  # Gestion des fichiers de configuration
  #
  # Méthode 1: Liens symboliques vers les fichiers du repo
  # (Recommandé si vous voulez modifier facilement)
  #
  # Placez les fichiers de config dans ~/dotfiles/hypr/ etc.
  # puis créez des liens:
  #
  # home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hypr";
  # home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/waybar";
  # home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kitty";
  # home.file.".config/wofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wofi";

  # Méthode 2: Copier les fichiers directement dans le Nix store
  # (Plus "pur" mais nécessite un rebuild à chaque modification)
  #
  # home.file.".config/hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
  # home.file.".config/hypr/colors.conf".source = ./dotfiles/hypr/colors.conf;
  # etc.

  # Variables d'environnement utilisateur
  home.sessionVariables = {
    EDITOR = "vim";  # ou votre éditeur préféré
    BROWSER = "firefox";  # ou votre navigateur préféré
    TERMINAL = "kitty";
  };

  # Services utilisateur
  systemd.user.services = {
    # Polkit agent
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}

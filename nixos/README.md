# Configuration NixOS - Exemples

Ce dossier contient des exemples de configuration pour NixOS.

## Fichiers

### `hyprland-config.nix`
Configuration système complète pour Hyprland avec toutes les dépendances.

**Installation:**
```bash
# Copier dans /etc/nixos/
sudo cp hyprland-config.nix /etc/nixos/

# Ajouter dans /etc/nixos/configuration.nix:
# imports = [ ./hyprland-config.nix ];

# Rebuild
sudo nixos-rebuild switch
```

### `home-manager.nix`
Configuration Home Manager pour gérer Hyprland au niveau utilisateur.

**Installation:**
```bash
# Importer dans votre home.nix
imports = [ ./path/to/home-manager.nix ];

# Rebuild
home-manager switch
```

## Quelle méthode choisir?

### Configuration système (`hyprland-config.nix`)
✅ Bon pour:
- Installation système-wide
- Partage entre plusieurs utilisateurs
- Gestion centralisée

❌ Nécessite:
- Accès sudo pour les modifications
- Rebuild système complet

### Home Manager (`home-manager.nix`)
✅ Bon pour:
- Configuration par utilisateur
- Pas besoin de sudo
- Gestion déclarative des dotfiles

❌ Nécessite:
- Home Manager installé
- Un peu plus complexe à configurer

### Hybride (Recommandé)
- Paquets système dans `configuration.nix`
- Dotfiles dans Home Manager
- Meilleur des deux mondes

## Exemple de configuration hybride

### `/etc/nixos/configuration.nix`
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hyprland-config.nix  # ← Import de la config Hyprland
  ];

  # Reste de votre configuration...
}
```

### `~/.config/home-manager/home.nix`
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hyprland-home.nix  # ← Import de la config Home Manager
  ];

  # Configuration utilisateur...
  home.username = "votre-nom";
  home.homeDirectory = "/home/votre-nom";
  home.stateVersion = "24.05";
}
```

## Post-installation

Après avoir installé les paquets, lancez le script d'installation:

```bash
cd ~/dot-hyprland
./install-nixos.sh
```

Ce script installera les fichiers de configuration dans `~/.config/`.

## Personnalisation

Les fichiers de configuration peuvent être modifiés directement dans `~/.config/` ou gérés via Home Manager pour une approche plus déclarative.

Voir [NIXOS-INSTALL.md](../NIXOS-INSTALL.md) pour plus de détails.

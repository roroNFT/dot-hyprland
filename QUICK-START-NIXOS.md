# Guide de lancement des scripts - NixOS

## Étape 1 : Récupérer les corrections

Les scripts ont été corrigés pour NixOS. Mettez à jour votre copie locale :

```bash
cd ~/dot-hyprland
git pull
```

## Étape 2 : Vérifier que les scripts sont exécutables

```bash
ls -l *.sh
```

Si ils ne le sont pas, rendez-les exécutables :

```bash
chmod +x install-nixos.sh customize-hyprland.sh
```

## Étape 3 : Installer les dépendances (IMPORTANT)

**Avant de lancer le script**, vous devez installer les paquets dans votre configuration NixOS.

### Option A : Installation rapide (copier-coller)

```bash
# Ouvrir la configuration NixOS
sudo nano /etc/nixos/configuration.nix
```

Ajoutez ces lignes dans la section `environment.systemPackages = with pkgs; [` :

```nix
# Hyprland et dépendances
kitty
wofi
waybar
swww
mako
libnotify
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
noto-fonts-emoji
polkit_gnome
xdg-desktop-portal-hyprland
qt5.qtwayland
qt6.qtwayland
imagemagick
jq
pywal
```

Activez aussi Hyprland si ce n'est pas déjà fait :

```nix
programs.hyprland = {
  enable = true;
  xwayland.enable = true;
};
```

Puis reconstruisez :

```bash
sudo nixos-rebuild switch
```

### Option B : Utiliser le fichier d'exemple

```bash
# Copier le fichier d'exemple
sudo cp ~/dot-hyprland/nixos/hyprland-config.nix /etc/nixos/

# Éditer configuration.nix
sudo nano /etc/nixos/configuration.nix
```

Ajoutez dans la section `imports` :

```nix
imports = [
  ./hardware-configuration.nix
  ./hyprland-config.nix  # ← Ajouter cette ligne
];
```

Puis :

```bash
sudo nixos-rebuild switch
```

## Étape 4 : Lancer le script d'installation

Une fois les paquets installés :

```bash
cd ~/dot-hyprland
./install-nixos.sh
```

Le script va vous demander confirmation avant d'installer.

### Que fait le script ?

1. ✅ Vérifie que vous êtes sur NixOS
2. ✅ Vérifie qu'Hyprland est installé
3. ✅ Liste les dépendances manquantes (si il y en a)
4. ✅ Sauvegarde vos configurations existantes dans `~/.config-backup-YYYYMMDD-HHMMSS/`
5. ✅ Crée tous les répertoires nécessaires
6. ✅ Installe les configurations Hyprland, Waybar, Kitty, Wofi, Mako
7. ✅ Crée le script wallpaper

## Étape 5 : Ajouter des wallpapers (optionnel)

```bash
# Créer le dossier si nécessaire
mkdir -p ~/Pictures/Wallpapers

# Copier vos images
cp /chemin/vers/vos/images/*.jpg ~/Pictures/Wallpapers/
```

## Étape 6 : Se connecter à Hyprland

1. **Déconnectez-vous** de votre session actuelle
2. Dans l'écran de connexion, **sélectionnez "Hyprland"**
3. **Connectez-vous**

## Raccourcis essentiels après connexion

- `SUPER + Return` : Ouvrir le terminal (Kitty)
- `SUPER + D` : Ouvrir le lanceur d'applications (Wofi)
- `SUPER + Q` : Fermer la fenêtre active
- `SUPER + 1-9` : Changer de workspace
- `Print` : Capture d'écran (zone sélectionnée)

## Dépannage

### Le script dit qu'il manque des dépendances

Si le script affiche des paquets manquants, ajoutez-les dans votre `configuration.nix` et relancez :

```bash
sudo nixos-rebuild switch
```

Puis relancez le script.

### Je veux juste tester sans installer les paquets

Vous pouvez lancer le script même sans tous les paquets. Il vous demandera si vous voulez continuer quand même.

### Alternative : Bash direct

Si le script ne se lance toujours pas :

```bash
bash ~/dot-hyprland/install-nixos.sh
```

## Documentation complète

- **NIXOS-INSTALL.md** : Guide complet NixOS avec troubleshooting
- **README.md** : Documentation générale
- **nixos/README.md** : Exemples de configurations

## Besoin d'aide ?

Si vous rencontrez des problèmes, partagez les messages d'erreur et je pourrai vous aider !

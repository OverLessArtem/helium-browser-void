# Helium Browser for Void Linux
This repository provides an xbps template and automated binary builds for the **Helium Browser**.

## Installation

### Method 1: Using the Binary Repository
Add this repository to your xbps configuration to receive updates directly from GitHub Releases:

```bash
# Add the repository
echo "repository=https://github.com/OverLessArtem/helium-browser-void/releases/latest/download" | sudo tee /etc/xbps.d/20-helium.conf

# Sync and install (xbps will prompt to import the public key automatically)
sudo xbps-install -S
sudo xbps-install -S helium-browser-bin
```

### Method 2: Manual Installation (Local Build)
If you want to build the package manually:
- Clone the [void-packages](https://github.com/void-linux/void-packages) repository.
- Copy the helium-browser-bin folder from this repo into void-packages/srcpkgs
- Run the build and install:

```bash
./xbps-src pkg helium-browser-bin
sudo xbps-install -R hostdir/binpkgs helium-browser-bin
```

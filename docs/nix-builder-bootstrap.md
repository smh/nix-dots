# Nix Builder LXC Bootstrap Guide

This guide documents how to set up a dedicated Nix builder LXC container on Proxmox for building NixOS LXC containers and VM images.

## Overview

The nix-builder container provides a native x86_64-linux environment for building NixOS images without emulation. It has direct access to Proxmox's template directories via bind mounts.

**Container Specs:**
- **Hostname:** nix-builder
- **OS:** Debian 12 (or later)
- **Resources:** 8 cores, 32GB RAM, 100GB disk
- **Bind Mount:** `/var/lib/vz` → `/proxmox` (access to templates, ISOs, and VM dumps)
- **Features:** nesting=1, fuse=1 (for Docker support if needed)

## Initial Container Setup (Proxmox Host)

### Option A: Create New Container

```bash
# SSH to Proxmox host
ssh root@ghostline.lan

# Download Debian template (if not already present)
pveam update
pveam download local debian-12-standard_12.7-1_amd64.tar.zst

# Create container (adjust ID if needed)
pct create 103 local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname nix-builder \
  --memory 32768 \
  --cores 8 \
  --rootfs vms:100 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --unprivileged 0 \
  --onboot 1 \
  --features nesting=1,fuse=1 \
  --swap 512

# Add bind mount for Proxmox storage
pct set 103 -mp0 /var/lib/vz,mp=/proxmox,shared=1

# Start container
pct start 103
```

### Option B: Repurpose Existing Container

```bash
# Change hostname
pct set <container-id> -hostname nix-builder

# Update hostname inside container
pct enter <container-id>
hostnamectl set-hostname nix-builder
echo "nix-builder" > /etc/hostname
exit

# Add/update bind mount
pct set <container-id> -mp0 /var/lib/vz,mp=/proxmox,shared=1

# Restart container
pct restart <container-id>
```

### Setup User Access

```bash
# Enter container
pct enter 103

# Create user (if not exists)
adduser smh
usermod -aG sudo smh

# Setup SSH key
su - smh
mkdir -p ~/.ssh
chmod 700 ~/.ssh

exit
```

### Add your SSH public key
```bash
ssh-copy-id nix-build
```


## Nix Installation (Inside Container)

```bash
# SSH into container as smh user
ssh smh@nix-builder.lan

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl git xz-utils

# Install Nix (multi-user/daemon mode)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Log out and back in to load Nix environment
exit
ssh smh@nix-builder.lan

# Verify Nix installation
nix --version
```

## Configure Nix

```bash
# Create Nix config directory
mkdir -p ~/.config/nix

# Enable flakes and configure build settings
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
max-jobs = auto
cores = 8
EOF

# Restart nix-daemon to pick up config
sudo systemctl restart nix-daemon
```

## Setup Repository

```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Setup SSH for GitHub
ssh-keygen -t ed25519 -C "nix-builder@ghostline"
cat ~/.ssh/id_ed25519.pub
# Copy the public key and add it to your GitHub account
# Settings → SSH and GPG keys → New SSH key

# Clone the nix-dots repository
cd ~
git clone git@github.com:yourusername/nix-dots.git
cd nix-dots

# Verify flake works
nix flake show
```

## Build Workflow

### Building LXC Containers

```bash
# Navigate to repo
cd ~/nix-dots

# Pull latest changes
git pull

# Build resurgam LXC
nix build .#packages.x86_64-linux.resurgam-lxc

# Copy to Proxmox template directory
cp result/tarball/nixos-system-x86_64-linux.tar.xz \
   /proxmox/template/cache/resurgam.tar.xz

# Or with timestamp
cp result/tarball/nixos-system-x86_64-linux.tar.xz \
   /proxmox/template/cache/resurgam-$(date +%Y%m%d).tar.xz
```

### Building VM Images

```bash
# Build Proxmox VM image
nix build .#packages.x86_64-linux.chasm-city

# Copy to Proxmox dump directory
cp result/*.vma.zst \
   /proxmox/dump/vzdump-qemu-900-$(date +%Y_%m_%d).vma.zst
```

## Deploying Built Images

### Deploy LXC Container

```bash
# On Proxmox host (ssh root@ghostline.lan)
pct create 101 local:vztmpl/resurgam.tar.xz \
  --hostname resurgam \
  --memory 32768 \
  --cores 8 \
  --rootfs vms:100 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --unprivileged 0 \
  --features nesting=1

# Start container
pct start 101

# Get IP address
pct exec 101 ip addr show eth0

# SSH into new container
ssh root@<container-ip>
# Default password: rema1000 (change immediately!)
passwd
```

### Deploy VM Image

```bash
# On Proxmox host
qmrestore /var/lib/vz/dump/vzdump-qemu-900-*.vma.zst 900

# Start VM
qm start 900
```

## Maintenance

### Update Nix

```bash
# Update Nix itself
sudo -i nix upgrade-nix

# Update nixpkgs
nix flake update ~/nix-dots
```

### Clean Build Cache

```bash
# Remove old build results
nix-collect-garbage -d

# Or keep last 7 days
nix-collect-garbage --delete-older-than 7d
```

### Update Repository

```bash
cd ~/nix-dots
git pull
```

## Troubleshooting

### Nix not found after installation
```bash
# Source the profile manually
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Or restart shell
exit
ssh smh@nix-builder.lan
```

### Permission denied on /proxmox
```bash
# Verify mount exists (on Proxmox host)
pct config 103 | grep mp0

# Verify mount inside container
ls -la /proxmox
df -h | grep proxmox

# If missing, add the mount:
pct set 103 -mp0 /var/lib/vz,mp=/proxmox,shared=1
pct restart 103
```

### Build fails with "out of disk space"
```bash
# Check disk usage
df -h

# Clean up old builds
nix-collect-garbage -d

# On Proxmox host, increase disk size
pct resize 103 rootfs +50G
```

## Advanced: Remote Building from Mac

You can configure your Mac to use the nix-builder as a remote builder:

```nix
# Add to machines/nostalgia/default.nix or modules/darwin/default.nix
nix.buildMachines = [{
  hostName = "nix-builder.lan";
  systems = ["x86_64-linux" "aarch64-linux"];
  maxJobs = 8;
  speedFactor = 2;
  supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  mandatoryFeatures = [ ];
}];

nix.distributedBuilds = true;
nix.extraOptions = ''
  builders-use-substitutes = true
'';
```

Then from your Mac:
```bash
# Build will automatically use remote builder
nix build .#packages.x86_64-linux.resurgam-lxc
```

## Directory Structure

```
nix-builder container:
├── /home/smh/nix-dots/          # Git repository
├── /proxmox/                     # Bind mount to Proxmox storage
│   ├── template/
│   │   ├── cache/               # LXC templates (.tar.xz)
│   │   └── iso/                 # VM ISO images
│   ├── dump/                    # VM backups (.vma.zst)
│   └── images/                  # Active VM disks
└── /nix/                        # Nix installation
```

## Quick Reference Commands

```bash
# Build LXC image
nix build .#packages.x86_64-linux.resurgam-lxc

# Build VM image
nix build .#packages.x86_64-linux.chasm-city

# Copy LXC to templates
cp result/tarball/*.tar.xz /proxmox/template/cache/

# Copy VM to dumps
cp result/*.vma.zst /proxmox/dump/

# Deploy LXC (on Proxmox host)
pct create <id> local:vztmpl/<name>.tar.xz [options...]

# Deploy VM (on Proxmox host)
qmrestore /var/lib/vz/dump/<name>.vma.zst <vmid>
```

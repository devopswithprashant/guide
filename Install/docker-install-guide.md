# Installing Docker
### A complete setup guide for Windows, macOS & Linux
*Docker Container Series · Companion Guide*

> **Who this is for:** Complete beginners with zero Docker experience. By the end of this guide, Docker will be installed, verified, and ready to use on your machine — whatever operating system you're on.

---

## Table of contents

1. [Before you start: system requirements](#1-before-you-start-system-requirements)
2. [Installing Docker on Windows](#2-installing-docker-on-windows)
3. [Installing Docker on macOS](#3-installing-docker-on-macos)
4. [Installing Docker on Linux](#4-installing-docker-on-linux)
5. [Final verification checklist](#5-final-verification-checklist)

---

## 1. Before you start: system requirements

Docker Desktop has minimum requirements for each operating system. Check the table below before downloading anything.

| Windows | macOS | Linux |
|---|---|---|
| Windows 10 (Build 19041+) or Windows 11, 64-bit | macOS 13 (Ventura) or later | Ubuntu 22.04/24.04, Debian 12, Fedora 40+, or RHEL 9 |
| WSL 2 enabled (installer can do this for you) | Apple Silicon (M1–M4) or Intel chip | 64-bit kernel with virtualization support |
| 4 GB RAM minimum (8 GB recommended) | 4 GB RAM minimum (8 GB recommended) | 4 GB RAM minimum (8 GB recommended) |
| Virtualization enabled in BIOS (Intel VT-x / AMD-V) | At least 6 GB free disk space | At least 6 GB free disk space |

> 💡 **Tip:** Not sure if virtualization is enabled on Windows? Open Task Manager → Performance tab → CPU. If it says "Virtualization: Enabled," you're good to go.

---

## 2. Installing Docker on Windows

Docker on Windows runs through Docker Desktop, which uses WSL 2 (Windows Subsystem for Linux) under the hood to run Linux containers efficiently.

### Step 1 — Enable WSL 2

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

This installs WSL 2 along with a default Ubuntu distribution. Restart your computer when prompted.

> 📝 **Note:** If WSL is already installed, run `wsl --update` instead to make sure you're on the latest version.

### Step 2 — Download Docker Desktop

1. Go to [docker.com/products/docker-desktop](https://docker.com/products/docker-desktop) and click "Download for Windows."
2. Make sure you select the correct build for your processor (most users: x86_64/AMD64).

### Step 3 — Run the installer

1. Double-click `Docker Desktop Installer.exe`.
2. On the configuration screen, make sure "Use WSL 2 instead of Hyper-V" is checked (this is the default and recommended option).
3. Click **Ok** and let the installer finish — this may take a few minutes.
4. Restart your machine if prompted.

### Step 4 — Launch and sign in

1. Open Docker Desktop from the Start menu.
2. Accept the service agreement.
3. Sign in or create a free Docker Hub account (optional at this stage, but recommended).
4. Wait for the whale icon in your system tray to stop animating — that means Docker Engine is running.

### Step 5 — Verify the installation

Open PowerShell or Command Prompt and run:

```powershell
docker --version
```

You should see something like:

```
Docker version 27.x.x, build xxxxxxx
```

Now run the test container:

```powershell
docker run hello-world
```

If you see a "Hello from Docker!" message, your installation is working correctly.

### Common Windows issues

- **"WSL 2 installation is incomplete"** → run `wsl --update` in PowerShell, then restart Docker Desktop.
- **Virtualization not enabled** → reboot into BIOS/UEFI settings and enable Intel VT-x or AMD-V.
- **Docker Desktop stuck on "Starting"** → restart the machine, then relaunch Docker Desktop.

---

## 3. Installing Docker on macOS

Docker Desktop for Mac comes in two builds — one for Apple Silicon (M1, M2, M3, M4) and one for Intel chips. Installing the wrong one will cause Docker to run slowly under emulation, or fail to start.

### Step 1 — Check your chip type

Click the Apple menu → About This Mac. Look for "Chip" or "Processor."

- Says "Apple M1 / M2 / M3 / M4" → download the **Apple Silicon** build.
- Says "Intel" → download the **Intel chip** build.

### Step 2 — Download Docker Desktop

Go to [docker.com/products/docker-desktop](https://docker.com/products/docker-desktop) and download the `.dmg` file matching your chip type.

### Step 3 — Install

1. Open the downloaded `Docker.dmg` file.
2. Drag the Docker icon into the Applications folder.
3. Open Docker from your Applications folder (or Spotlight search).
4. macOS will ask for confirmation to open an app downloaded from the internet — click **Open**.
5. Enter your Mac password when prompted, since Docker needs to install some system-level networking components.

### Step 4 — Wait for Docker to start

You'll see a whale icon appear in your menu bar. Once it stops animating, Docker Engine is running and ready.

### Step 5 — Verify the installation

Open Terminal and run:

```bash
docker --version
docker run hello-world
```

Seeing the "Hello from Docker!" message confirms everything is working.

### Common macOS issues

- **Installer hangs at "Installing"** → this can take several minutes on first run while macOS performs security checks. Be patient.
- **"Rosetta required" warning on Apple Silicon** → install it by running: `softwareupdate --install-rosetta`
- **Docker command not found** → make sure Docker Desktop is actually running (check the menu bar icon), then restart your terminal.

---

## 4. Installing Docker on Linux

On Linux, you have two options: Docker Desktop (GUI, available for Ubuntu/Debian/Fedora) or Docker Engine (CLI-only, lighter, and the most common choice for servers and experienced users). This guide covers Docker Engine on Ubuntu/Debian — the most widely used path.

### Step 1 — Remove old versions (if any)

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

### Step 2 — Set up Docker's apt repository

Update your package index and install prerequisites:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

Add Docker's official GPG key:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Add the repository to apt sources:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Step 3 — Install Docker Engine

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

> 📝 **Note:** This installs Docker Engine, the CLI, containerd, Buildx, and the Compose plugin — everything you need, all in one go.

### Step 4 — Run Docker without sudo (optional but recommended)

By default, Docker commands require `sudo`. To run Docker as your regular user:

```bash
sudo usermod -aG docker $USER
```

Log out and log back in (or run `newgrp docker`) for the group change to take effect.

### Step 5 — Verify the installation

```bash
docker --version
docker run hello-world
```

If you see the "Hello from Docker!" message, you're all set.

### Other distributions

- **Fedora / RHEL / CentOS:** use `dnf install` instead of `apt-get`, with Docker's RPM repository.
- **Arch Linux:** install via `pacman -S docker`, then enable with `sudo systemctl enable --now docker`.
- **Prefer a GUI?** Docker Desktop for Linux is available as a `.deb` or `.rpm` package directly from Docker's website.

### Common Linux issues

- **"permission denied" on docker commands** → you likely skipped Step 4, or haven't logged out/in yet.
- **Docker daemon not running** → start it manually with: `sudo systemctl start docker`
- **Want Docker to start automatically on boot** → `sudo systemctl enable docker`

---

## 5. Final verification checklist

Whichever OS you're on, confirm all of the following before moving to the next video:

- [ ] `docker --version` returns a version number without errors
- [ ] `docker run hello-world` prints the "Hello from Docker!" success message
- [ ] Docker Desktop (Windows/Mac) shows a running whale icon, or `systemctl status docker` (Linux) shows "active (running)"
- [ ] You can run Docker commands without needing to reinstall or restart constantly
- [ ] (Linux users) you can run `docker ps` without typing `sudo` first


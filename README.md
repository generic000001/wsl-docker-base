# WSL Docker Base

A minimal Ubuntu WSL2 environment managed as Infrastructure as Code, with a Windows-first setup workflow.

## Includes

- Docker Engine

## Requirements

- Windows 10 or 11 with WSL2 support
- The Windows Subsystem for Linux (WSL)
- Administrator access for the initial WSL installation

## Setup from Windows

Install WSL once, if it is not already installed. Open PowerShell as Administrator and run:

```powershell
wsl --install
```

Restart Windows if prompted. Then clone this repository from PowerShell:

```powershell
git clone https://github.com/<username>/wsl-docker-base.git
cd wsl-docker-base
```

Run the Windows launcher from an already-open PowerShell window. Running the `.ps1` file by double-clicking can close the window before you see an error. It opens Ubuntu WSL2 and runs the Linux setup scripts from the Windows clone; there is no need to clone the repository again inside Ubuntu:

```powershell
.\setup.ps1
```

The launcher automatically restarts WSL so the Docker group membership takes effect, then verifies the installation. To verify again later, run:

```powershell
.\setup.ps1 -VerifyOnly
```

The launcher checks that WSL and the `Ubuntu` distribution are installed and running as WSL2. If Ubuntu is missing, it installs the distribution automatically. The first installation may require a restart; run the launcher again afterward.

The setup can be run again safely. It updates Ubuntu, installs required prerequisites, skips Docker installation when Docker is already available, and verifies Docker with the `hello-world` container. `-VerifyOnly` performs only the verification step and does not install or update anything.

## Dispose of the environment

The Ubuntu distribution is persistent until you explicitly delete it. To make the environment disposable, run this from PowerShell:

```powershell
.\teardown.ps1
```

The command requires you to type `DELETE` and permanently removes the `Ubuntu` distribution, including installed packages, files, Docker images, containers, and volumes. Use `.\teardown.ps1 -Force` for scripted cleanup. Run `wsl --install --distribution Ubuntu` again before using `.\setup.ps1` to create a fresh environment.

## Repository layout

```
.
├── scripts/
│   ├── setup.sh     # Installs Docker inside Ubuntu
│   └── verify.sh    # Verifies the Docker installation
├── setup.ps1        # Windows launcher (calls scripts/setup.sh via WSL)
└── teardown.ps1     # Removes the Ubuntu WSL distribution
```

## Direct WSL usage

If you are already working inside Ubuntu, the shell scripts can be run directly:

```bash
bash scripts/setup.sh
bash scripts/verify.sh
```

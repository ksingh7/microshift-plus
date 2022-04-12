## Introduction

[Microshift](https://github.com/redhat-et/microshift) is a small form factor OpenShift/Kubernetes optimized for edge computing

This repository provides helper script to setup/purge Microshift environments for my homelab.

## Usage
- Install [Podman](https://podman.io/getting-started/installation)
- Get the code
```
git clone https://github.com/ksingh7/microshift.git
cd microshift
```
- Lanuch Microshift environment (MacOS)
```
./macos_create_microshift.sh
```
- Purge Microshift environment (MacOS)
```
./macos_purge_microshift.sh
```
## Features
This repository provides the following features
- Initialize & Start Podman Machine (for MacOS)
- Set `rootful` mode for Microshift's Privileged container
- Launch Microshift `podman run ...`
- Check and wait for Microshift to be Ready
- Setup OpenShift Web/Developer Console for Microshift
- Get the URL of OpenShift Web Console for easy access
- Setup OpenShift Operator Lifecycle Manager (OLM)

## Sample Output
```

```
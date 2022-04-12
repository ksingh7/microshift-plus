## Introduction

[Microshift](https://github.com/redhat-et/microshift) is a small form factor OpenShift/Kubernetes optimized for edge computing. 

[Microshift-Man](https://github.com/ksingh7/microshift-man) provides helper script to setup & purge Microshift environments runing on Podman for dev/test/homelab setup.

## Features
[Microshift-Man](https://github.com/ksingh7/microshift-man) provides the following features
- Initialize & Start Podman Machine (for MacOS)
- Set `rootful` mode needed for Microshift's Privileged container
- Launch Microshift Container
- Check and wait for Microshift to become Ready
- Patch OpenShift Router to use `nip.io` for outbound routing
- Setup OpenShift Web/Developer Console for Microshift
- Get the URL of OpenShift Web Console for easy access
- Setup OpenShift Operator Lifecycle Manager (OLM) (For Operator Catalog)
- Scale down OLM packageserver replica to 1 (optimiaztion, default is 2)

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

## Sample Output
```
Creating Podman Machine...
Starting Podman Machine...
Setting rootful mode...
Launching Microshift...
Waiting for Microshift to become Ready...
Microshift is Now Ready ...
Setting up OpenShift Web Console ...
----------------------------------------------------------
serviceaccount/openshift-console created
secret/openshift-console-secret created
clusterrolebinding.rbac.authorization.k8s.io/openshift-console-cluster-role-binding created
service/kube-api created
deployment.apps/openshift-console-deployment created
service/openshift-console-service created
route.route.openshift.io/openshift-console created
pod/openshift-console-deployment-7c8785cc5c-vcmr4 condition met
----------------------------------------------------------
############### OpenShift Console is Ready ###############################
http://openshift-console.apps.127.0.0.1.nip.io
##########################################################################
Setting up OLM ...
OLM Setup Completed ...
############### Microshift Setup Completed ###############################
OpenShift Console URL      : http://openshift-console.apps.127.0.0.1.nip.io
OpenShift / Kubectl Access : podman exec -it microshift /bin/bash
##########################################################################
```
> Note : At my homelab it takes about 5 Minutes to complete, your milage may vary
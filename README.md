```
brew install podman

podman --version
time podman machine init --cpus 4 --memory 6000
time podman machine start
time podman machine set --rootful
podman machine list
```
```
time podman run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 -p 80:80 -p 8080:8080 quay.io/microshift/microshift-aio:latest


podman exec -it microshift /bin/bash
oc get nodes
oc get po -A -w

oc create -f https://raw.githubusercontent.com/ksingh7/jade-shooter-app/main/jade-shooter-aio.yaml
oc expose service/jade-shooter-service --hostname=jade-shooter-default.apps.127.0.0.1.nip.io

```
```
podman rm -f microshift
podman volume prune -f
podman machine stop
podman machine rm --force
```

- Patch OpenShift Route for default subdomain
```
oc -n openshift-ingress set env deployment/router-default --overwrite ROUTER_SUBDOMAIN='${name}-${namespace}.apps.127.0.0.1.nip.io' ROUTER_ALLOW_WILDCARD_ROUTES="true" ROUTER_OVERRIDE_HOSTNAME="true"
```

- OpenShift Console Setup
```
oc create -f https://raw.githubusercontent.com/ksingh7/microshift/main/01_openshift_console.yaml
```

- OLM Setup
```
curl -L https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh -o install.sh
chmod +x install.sh
./install.sh v0.20.0
```

- Install Podman on Fedora35
```
sudo su
dnf copr enable rhcontainerbot/podman4
dnf install podman

command -v setsebool >/dev/null 2>&1 || sudo setsebool -P container_manage_cgroup true

podman run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 -p 80:80 -p 8080:8080 quay.io/microshift/microshift-aio:latest

podman exec -it microshift /bin/bash
oc get nodes
oc get po -A -w

```
- Grap kubeconfig file
```
mkdir ~/.kube
sudo podman cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig ~/.kube/config
sudo chown `whoami`: ~/.kube/config
```
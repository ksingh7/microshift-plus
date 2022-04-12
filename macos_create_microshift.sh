#!/bin/bash

start=$(date +'%s')

echo "Creating Podman Machine..."
podman machine init --cpus 4 --memory 6000 &> /dev/null

echo "Starting Podman Machine..."
podman machine start &> /dev/null

echo "Setting rootful mode..."
podman machine set --rootful

echo "Launching Microshift..."
podman run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 -p 80:80 -p 8080:8080 quay.io/microshift/microshift-aio:latest &> /dev/null
echo "Waiting for Microshift to become Ready..."
sleep 100
default_dns_pod=$(podman exec microshift oc get po -A | grep -i dns-default | awk '{print $2}')
podman exec microshift oc wait --for=condition=Ready --timeout=10m pod/$default_dns_pod -n openshift-dns

echo "Microshift is Now Ready ..."

echo "Setting up OpenShift Web Console ..."
echo "----------------------------------------------------------"
podman exec microshift oc create -f https://raw.githubusercontent.com/ksingh7/microshift/main/01_openshift_console.yaml
openshift_console_pod=$(podman exec microshift oc get po -A | grep -i openshift-console-deployment | awk '{print $2}')
podman exec microshift oc wait --for=condition=Ready --timeout=10m pod/$openshift_console_pod -n kube-system
echo "----------------------------------------------------------"

url=$(podman exec microshift oc get route -n kube-system openshift-console -o jsonpath='{.spec.host}')
echo "############### OpenShift Console is Ready ###############################"
echo "http://$url"
echo "##########################################################################"

echo "Setting up OLM ..."
echo "----------------------------------------------------------"
podman exec microshift curl -L https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh -o install.sh &> /dev/null
podman exec microshift chmod +x install.sh
podman exec microshift ./install.sh v0.20.0 &> /dev/null
echo "OLM Setup Completed ..."
echo "############### Microshift Setup Completed ###############################"
echo "OpenShift Console URL      : http://$url"
echo "OpenShift / Kubectl Access : podman exec -it microshift /bin/bash"
echo "##########################################################################"

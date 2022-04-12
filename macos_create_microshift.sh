#!/bin/bash

echo "Creating Podman Machine..."
podman machine init --cpus 4 --memory 6000

echo "Starting Podman Machine..."
podman machine start

echo "Setting rootful mode..."
podman machine set --rootful

echo "Launching Microshift..."
podman run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 -p 80:80 -p 8080:8080 quay.io/microshift/microshift-aio:latest
echo "Waiting for Microshift to become Ready..."
sleep 100
default_dns_pod=$(podman exec microshift oc get po -A | grep -i dns-default | awk '{print $2}')
podman exec microshift oc wait --for=condition=Ready --timeout=10m pod/$default_dns_pod -n openshift-dns

echo "Microshift is Now Ready, and here are all running pods ..."
podman exec microshift oc get po -A

echo "Setting up OpenShift Web Console ..."
podman exec microshift oc create -f https://raw.githubusercontent.com/ksingh7/microshift/main/01_openshift_console.yaml

echo "Waiting for OpenShift Web Console to be ready ..."
openshift_console_pod=$(podman exec microshift oc get po -A | grep -i openshift-console-deployment | awk '{print $2}')
podman exec microshift oc wait --for=condition=Ready --timeout=10m pod/$openshift_console_pod -n openshift-console

echo "OpenShift Web Console is Now Ready, your Console URL is"
url=$(podman exec microshift oc get route -n kube-system openshift-console -o jsonpath='{.spec.host}')
echo "--------------------------------------------------------------------"
echo "http://$url"
echo "--------------------------------------------------------------------"

echo "To use oc/kubectl client, run the following command"
echo "--------------------------------------------------------------------"
echo "podman exec -it microshift /bin/bash"
echo "--------------------------------------------------------------------"
echo "Creating Podman Machine..."
podman machine init --cpus 4 --memory 6000 &> /dev/null

echo "Starting Podman Machine..."
podman machine start &> /dev/null

echo "Setting rootful mode..."
podman machine set --rootful

echo "Launching Microshift..."
podman run -d --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 -p 80:80 -p 8080:8080 quay.io/microshift/microshift-aio:latest &> /dev/null
echo "Waiting for Microshift to become Ready..."
sleep 100
default_dns_pod=$(podman exec microshift oc get po -A | grep -i dns-default | awk '{print $2}')
podman exec microshift oc wait --for=condition=Ready --timeout=10m pod/$default_dns_pod -n openshift-dns &> /dev/null

echo "Microshift is Now Ready ..."
podman exec microshift oc get po -A
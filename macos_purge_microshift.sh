#!/bin/bash
echo "Removing Microshift Container ..."
podman rm -f microshift &> /dev/null
echo "Removing Microshift Container Volumes ..."
podman volume prune -f &> /dev/null	
echo "Stopping Podman Machine ..."
podman machine stop
echo "Removing Podman Machine ..."
podman machine rm --force
echo "Verifying Podman Machine is removed or not ..."
podman machine list
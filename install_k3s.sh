#!/bin/bash

set -e

echo "[+] Updating system and installing curl..."
sudo apt-get update -y
sudo apt-get install -y curl

echo "[+] Installing latest k3s (single-node)..."
curl -sfL https://get.k3s.io | sh -

echo "[+] Verifying cluster..."
sudo k3s kubectl get nodes

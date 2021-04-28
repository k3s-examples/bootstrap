if [ $(id -u) -ne 0 ]; then
    echo Must run as root
    exit 1
fi

# Run this on the machine you want to install k3s server.
read -p "Enter server name ($(hostname))" NEW_NODE_NAME
if [ ! -z ${NEW_NODE_NAME} ]; then
    hostnamectl set-hostname ${NEW_NODE_NAME}
    read -p "System will change ..."
    reboot now
fi

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable traefik
echo
echo Token for nodes is:
cat /var/lib/rancher/k3s/server/token
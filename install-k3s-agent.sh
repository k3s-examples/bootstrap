#!/bin/bash
if [ $(id -u) -ne 0 ]; then
    echo Must run as root
    exit 1
fi

# Run this on the machine you want to install k3s server.
read -p "Enter agent host name ($(hostname))" NEW_NODE_NAME
if [ ! -z ${NEW_NODE_NAME} ]; then
    hostnamectl set-hostname ${NEW_NODE_NAME}
    read -p "System will change ..."
    reboot now
fi


read -p "Enter master node URL (http://some.dns:6443)> " MASTER_URL
read -p "Enter master node TOKEN> " MASTER_TOKEN


curl -sfL https://get.k3s.io | sh -s - agent --token ${MASTER_TOKEN} --server ${MASTER_URL}

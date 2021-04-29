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


read -p "Enter master node URL (https://some.dns:6443) > " CLUSTER_REGISTRATION_SERVER_URL
read -p "Enter master node TOKEN > " CLUSTER_REGISTRATION_TOKEN
read -p "Enter node LABEL (key=value) > " AGENT_LABEL

if [ -z ${AGENT_LABEL} ]; then
  curl -sfL https://get.k3s.io | sh -s - agent --token ${CLUSTER_REGISTRATION_TOKEN} --server ${CLUSTER_REGISTRATION_SERVER_URL}
else
  curl -sfL https://get.k3s.io | sh -s - agent --token ${CLUSTER_REGISTRATION_TOKEN} --server ${CLUSTER_REGISTRATION_SERVER_URL} --node-label ${AGENT_LABEL}
fi
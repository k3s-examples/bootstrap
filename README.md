# Getting started with k3s
I am a big fan of this product from Rancher. I have been using it for some time and it does the work for me and my team at develop/staging environments and soon in production.

# Single server cloud
install-k3-server-single file helps prepare a server to become a master node in the cloud. Its quit simple with k3s...

To start a new k3s master server you need to have root privileges and run:
```
source <(curl -sfL https://raw.githubusercontent.com/k3s-examples/cluster-init/main/install-k3s-server-single.sh)
```

### Setting host name
The script will first ask for the name of the node. Default is the host name of the machine. k3s will turn the host name the name of the node in its cloud. So if you have several nodes in your cloud, its a good idea to give them different names... 

### Disabling Traefik
The script will ask if you want to change the default Traefik ingress controller. You would want to change the traefik ingress if you plan to use multiple servers cloud. For some technical reasons Traefik no logger support multi server cloud deployment on k3s. A real bummer. And since your yaml definitions should go all the way from develop to production, you need to deside on this, very early in your project. 

> I always select to switch the Traefik with nginx ingress, so the default is Y to disable Traefik

If you disable Traefik the script will install nginx ingress controller for you.

At the end of the process the script prints out the new cloud token from k3s `cat /var/lib/rancher/k3s/server/token`

### Configuring your kubectl to work with the new cloud

To view the configuration needed to connect to the new cloud, run on the node you just installed the command:
` ks3 kubectl config view --raw`

This will print out the configuration for kubectl. And example is:
```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUyTVRrMk5ESTNNalF3SGhjTk1qRXdOREk0TWpBME5USTBXaGNOTXpFd05ESTJNakEwTlRJMApXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUyTVRrMk5ESTNNalF3V1RBVEJnY3
    ....
    server: https://127.0.0.1:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrVENDQVRlZ0F3SUJBZ0lJUG4vem91TlBPSjB3Q2dZSUtvWkl6ajBFQXdJd0l6RWhNQjhHQTFVRUF3d1kKYXpOekxXTnNhV1Z1ZEMxa....
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSU1mcitFZmRiQzNHQ3hXTVltbGhITHB0R1ljaks4bnUzeWZkdis4YmZDakZvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFU....

```

Note the server field of the cluster configuration. If you plan to connect to the cloud from a remote machine you will need to change this to the ip of the cloud master host. 
For example, say you want to copy this kubectl config to your pc. The cloud master node public IP is 1.2.3.4. The configuration file will look like:

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUyTVRrMk5ESTNNalF3SGhjTk1qRXdOREk0TWpBME5USTBXaGNOTXpFd05ESTJNakEwTlRJMApXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUyTVRrMk5ESTNNalF3V1RBVEJnY3
    ....
    server: https://1.2.3.4:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrVENDQVRlZ0F3SUJBZ0lJUG4vem91TlBPSjB3Q2dZSUtvWkl6ajBFQXdJd0l6RWhNQjhHQTFVRUF3d1kKYXpOekxXTnNhV1Z1ZEMxa....
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSU1mcitFZmRiQzNHQ3hXTVltbGhITHB0R1ljaks4bnUzeWZkdis4YmZDakZvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFU....

```

# Terms and definitions used by k3s

To make things clear, K8s uses the terms of manager and worker nodes in the cluster. k8s also make clears who is doing what (worker running the actual objects....). In k3s they use the term master,server and agent. Agent is the simplest, is can have the role of a worker kublet. A server has a role of worker and manager. This means that a server manage the work and running the k8s objects.
Finaly a master is a server that is also the registration point of the cloud. If you define a cluster with several servers than one of them (the first you deploy) should be the master. The master holds a token to be used by the rest of the nodes to join the cloud...

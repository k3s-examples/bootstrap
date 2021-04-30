# Getting started with k3s
I am a big fan of this product from Rancher. I been using it for some time and it does the work for me and my team at develop/staging environments and soon in production.

Rancher made k3s deployment very easy and convinient, so I use their solution a lot. There for I create some quick scripts and demo (simple) YAML files to have a quick bootstrap when configuring a new service.

#Install k3s server

To make things clear, K8s uses the terms of manager and worker nodes in the cluster. k8s also make clears who is doing what (worker running the actual objects....). In k3s they use the term master,server and agent. Agent is the simplest, is can have the role of a worker kublet. A server has a role of worker and manager. This means that a server manage the work and running the k8s objects.
Finaly a master is a server that is also the registration point of the cloud. If you define a cluster with several servers than one of them (the first you deploy) should be the master. The master holds a token to be used by the rest of the nodes to join the cloud...




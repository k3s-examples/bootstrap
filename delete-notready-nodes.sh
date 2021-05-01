#!/bin/bash



NOT_READY_NODES=$(kubectl get nodes | grep  'NotReady' | awk '{print $1}')

while IFS= read -r nodeName; do
	if [[ ! $nodeName =~ [^[:space:]] ]] ; then
  		continue
	fi
	echo "Found $nodeName node to be dead, draining..."
	kubectl delete $nodeName
done <<< "$NOT_READY_NODES"

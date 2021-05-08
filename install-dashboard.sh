kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
echo "check progress with : kubectrl get all -n kubernetes-dashboard"
echo "After dashboard deployed you can see it by:"
echo "kubectl proxy"
echo "Then open browser to:"
echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/."
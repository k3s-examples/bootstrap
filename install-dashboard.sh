kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

echo "check progress with : kubectrl get all -n kubernetes-dashboard"
echo "After Dashboard is deployed, create authorize user by running:"
echo "kubectl apply -f dashboard-rbac-account.yaml"
echo "After success creation of admin-user, you can gain a token by running"
echo "kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')"
echo "After dashboard deployed and gaining admin-user token you can see the dash board by:"
echo "kubectl proxy"
echo "Then open browser to:"
echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/."
echo "If you applied dashboard-rbac-account, than dashboard token is:"
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml
docker build -t jacob/otot-a1-nodeserver:latest ./app
kind load docker-image --name jacob/otot-a1-nodeserver:latest
kubectl apply -f "k8s/manifests/k8s/backend_deployment.yml"
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
until kubectl -n ingress-nginx get deploy | grep -m 1 "1/1"; do sleep 3 ; done
kubectl apply -f "k8s/manifests/k8s/backend-service.yml"
kubectl apply -f "k8s/manifests/k8s/backend-ingress.yml"

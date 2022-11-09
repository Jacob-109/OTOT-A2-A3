# Create Cluster
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml
# Check nodes created
kubectl get nodes

# Label node as ingressready
kubectl label node kind-1-worker ingress-ready=true
kubectl label node kind-1-worker2 ingress-ready=true
kubectl label node kind-1-worker3 ingress-ready=true

# Apply backend-deployment
kubectl apply -f "k8s/manifests/k8s/backend-deployment.yaml"

# Apply backend-service
kubectl apply -f "k8s/manifests/k8s/backend-service.yaml"

# Build app and load image
kind load docker-image otot-a1-nodeserver --name kind-1

# Creating ingress controller
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
until kubectl -n ingress-nginx get deploy ; do sleep 3m ; done

# Create ingress
kubectl apply -f "k8s/manifests/k8s/backend-ingress.yaml"

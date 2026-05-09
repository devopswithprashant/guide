# ArgoCD setup in Minikube cluster

## PHASE 1 — Prerequisites & Setup

### Step 1: Install Required Tools

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Minikube
brew install minikube

# Install kubectl
brew install kubectl

# Install Docker Desktop (if not installed)
brew install --cask docker

# Verify installs
minikube version
kubectl version --client
docker --version
```

### Step 2: Start Minikube
```bash
# Start minikube with enough resources
minikube start --cpus=2 --memory=4096 --driver=docker

# Verify it's running
minikube status
kubectl get nodes
```


## PHASE 2 — Install ArgoCD on Minikube

### Step 3: Install ArgoCD
```bash
# Create argocd namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for all pods to be ready (takes ~2 min)
kubectl wait --for=condition=available --timeout=300s deployment --all -n argocd

# Check all pods are Running
kubectl get pods -n argocd
```


### Step 10: Access ArgoCD UI
```bash
# Port-forward the ArgoCD server to localhost
kubectl port-forward svc/argocd-server -n argocd 8080:443
#Open in browser: https://localhost:8080 (accept the self-signed cert warning)
```
```bash
# Get the initial admin password (in a NEW terminal tab)
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo

# Login with:
# Username: admin
# Password: (output from above command)
```




### [Optional] Forcefully remove a stuck app from argoCD

```bash
kubectl patch app <APP_NAME> -n argocd -p '{"metadata": {"finalizers": null}}' --type merge
```

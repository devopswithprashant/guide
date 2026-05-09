# ArgoCD setup in EKS CLuster

## Step 1 — Create namespaces
```bash
# Make sure you're on your EKS cluster
aws eks update-kubeconfig --name <your-cluster-name> --region <region>

# Create all namespaces upfront
kubectl create namespace argocd

# Verify
kubectl get namespaces
```

## Step 2 - Install argoCD on eks cluster
```bash
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#Wait for all pods to come up:
kubectl get pods -n argocd -w
# Wait until all show Running
# argocd-server-xxx          1/1   Running
# argocd-repo-server-xxx     1/1   Running
# argocd-application-controller-xxx  1/1   Running
# argocd-redis-xxx           1/1   Running
# argocd-dex-server-xxx      1/1   Running
```

## Step 3 - Get admin password:
```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

## Step 4 - Patch ArgoCD server service to LoadBalancer
```bash
kubectl patch svc argocd-server -n argocd \
  -p '{"spec":{"type":"LoadBalancer"}}'
  
# Wait for AWS to provision the ELB (takes ~2-3 mins):
kubectl get svc argocd-server -n argocd -w
# Wait until EXTERNAL-IP column shows a hostname instead of <pending>
```



### [OPTIONAL] Delete Applications and ArgoCD

#### Step 1 — Delete ArgoCD Applications first
Always delete apps before ArgoCD itself, otherwise the finalizers will hang:
```bash
# Delete all applications
kubectl delete application --all -n argocd

# Verify
kubectl get applications -n argocd
# Should return: No resources found

#If any app is stuck in Terminating due to finalizers:
# Remove finalizer manually to force delete
kubectl patch application my-app-dev -n argocd \
  -p '{"metadata":{"finalizers":[]}}' \
  --type merge

# Repeat for each stuck app
kubectl patch application my-app-qa -n argocd \
  -p '{"metadata":{"finalizers":[]}}' \
  --type merge
```

#### Step 2 — Delete ArgoCD itself
```bash
kubectl delete -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

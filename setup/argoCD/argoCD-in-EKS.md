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

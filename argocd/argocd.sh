if [[ "$(kubectl get pods -n argocd| tail -1 | awk '{print $3}')" != "Running" ]]; then
    cowsay Setting up argocd
    # https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/
    kubectl create namespace argocd
    kubectl label namespace argocd istio-injection=enabled --overwrite
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl apply -n argocd -f /vagrant/argocd/argocd.gateway.yaml # Istio service gateway https://istio.io/latest/docs/reference/config/networking/gateway/
    kubectl apply -n argocd -f /vagrant/argocd/argocd.virtualservice.yaml # Istio virtual service https://istio.io/latest/docs/reference/config/networking/virtual-service/
    kubectl patch deployment -n argocd argocd-server --patch-file /vagrant/argocd/argocd-server.deployment.patch.yaml # patch argocd-server to avoid tls errors https://argo-cd.readthedocs.io/en/stable/operator-manual/tls/#inbound-tls-options-for-argocd-server
    kubectl apply -n argocd -f /vagrant/argocd/argocd-redis.networkpolicy.patch.yaml # remove egress from argocd-redis network policy to avoid istio errors https://github.com/argoproj/argo-cd/issues/11546
    cowsay Waiting ArgoCD...
    kubectl rollout restart deployment argocd-server -n argocd  # Restart argocd-server to apply the patches
    kubectl rollout restart deployment argocd-redis -n argocd  # Restart argocd-redis to apply the patches
    while [[ "$(kubectl get pods -n argocd | tail -1 | awk '{print $3}')" != "Running" ]]; do
        cowsay "Waiting Argocd..."
        sleep 5
    done
fi
cowsay Argocd is running!
# Files in the argocd folder
# Reference for ingresses: https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/

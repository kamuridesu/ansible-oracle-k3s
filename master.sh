. /vagrant/common.sh
PATH="$PATH:/usr/games"
export PATH
if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
    cowsay Installing K3s...
    curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik --tls-san 10.0.1.100 --advertise-address 10.0.1.100" sh -
    mkdir -p /home/vagrant/.kube
    cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
fi
cowsay K3s is running!

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

if [[ "$(kubectl get pods -n calico-apiserver | tail -1 | awk '{print $3}')" != "Running" ]]; then
    cowsay "Installing Tigera Operator for Calico..."
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/tigera-operator.yaml
    cowsay "Installing Calico..."
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/custom-resources.yaml
    while [[ "$(kubectl get pods -n calico-apiserver | tail -1 | awk '{print $3}')" != "Running" ]]; do
        cowsay "Waiting Calico resources..."
        sleep 5
    done
fi
cowsay "Calico is running!"

which helm > /dev/null; if [ "$?" != "0" ]; then
    cowsay "Installing Helm"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
fi

if [[ "$(kubectl get pods -n istio-ingress | tail -1 | awk '{print $3}')" != "Running" ]]; then
    cowsay "Setting up Istio"
    # Start from here: https://istio.io/latest/docs/setup/install/helm/
    helm repo add istio https://istio-release.storage.googleapis.com/charts
    helm repo update
    kubectl create namespace istio-system
    helm install istio-base istio/base -n istio-system
    helm install istiod istio/istiod -n istio-system --wait
    # On step four, from here: https://istio.io/latest/docs/setup/additional-setup/gateway/
    cowsay C"reating Istio ingress gateway"
    kubectl create namespace istio-ingress
    kubectl label namespace istio-ingress istio-injection=enabled # https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#automatic-sidecar-injection
    helm install istio-ingressgateway istio/gateway -n istio-ingress
    cowsay "Waiting Istio..."
    while [[ "$(kubectl get pods -n istio-ingress | tail -1 | awk '{print $3}')" != "Running" ]]; do
        sleep 5
    done
fi
cowsay "Istio is running!"

. /vagrant/argocd/argocd.sh

kubectl get nodes -o wide

# bash /vagrant/configs/shell/provision_master.sh
vagrant ssh master01 -c "cat /home/vagrant/.kube/config" | tail -n +2 | sed -e 's/127.0.0.1/10.0.1.100/' > /home/kamuri/.config/OpenLens/kubeconfigs/4eb7e39b-4490-4e6a-9ff4-540b2289e348
# vagrant ssh master01 -c "k3s token create" > agent.token

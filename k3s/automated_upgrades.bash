set -x
repo_link=https://github.com/rancher/system-upgrade-controller/releases/latest/download
crd=${repo_link}/crd.yaml
system_upgrade_controller=${repo_link}/system-upgrade-controller.yaml

kubectl apply -f ${crd} -f ${system_upgrade_controller}
kubectl apply --filename ./automated_upgrades.yaml

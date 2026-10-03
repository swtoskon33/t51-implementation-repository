# TeraFlowSDN (QKD)

**Requirements:** Ubuntu, MicroK8s with the add-ons of the ETSI deployment guide, Docker, Python.
**Requires testbed:** Kubernetes (MicroK8s) host, and QKD nodes or the TeraFlowSDN mock QKD node.

```bash
sudo snap install microk8s --classic
sudo snap alias microk8s.kubectl kubectl
# enable the add-ons listed in the deployment guide and wait until all pods are Running
git clone https://labs.etsi.org/rep/tfs/controller.git ~/tfs-ctrl && cd ~/tfs-ctrl
source my_deploy.sh
./deploy/all.sh
# WebUI: http://127.0.0.1/webui
```

## Known issues

- A dedicated Kubernetes host is required.
- MicroK8s add-ons must be enabled before deployment.
- Licence to be confirmed from the ETSI repository.

Deployment guide: https://tfs.etsi.org/documentation/develop/deployment_guide/

## Validation

Not yet tested. Instructions are taken from the upstream documentation.

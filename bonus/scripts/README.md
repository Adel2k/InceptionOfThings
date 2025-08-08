## 🚀 GitLab Deployment on k3d with Traefik

This project provides scripts and configuration to deploy a GitLab instance with GitLab Runner using Helm on a lightweight [k3d](https://k3d.io/) Kubernetes cluster. It uses [Traefik](https://doc.traefik.io/traefik/) as an ingress controller.

---

### 📁 Repository Structure

```
.
├── install-gitlab.sh             # Script to deploy GitLab, GitLab Runner, Traefik, and k3d cluster
├── delete.sh                     # Script to uninstall and delete all resources
├── .gitlab-ci.yaml               # CI/CD pipeline configuration for GitLab
├── gitlab-values.yaml            # Helm values for GitLab
├── gitlab-runner-values.yaml     # Helm values for GitLab Runner
```

---

### ⚙️ Prerequisites

* Docker
* `k3d`
* `kubectl`
* `helm`

---

### 🛠️ Deployment

To spin up the entire environment:

```bash
chmod +x install-gitlab.shll-gitlab.shat it does:

* Creates a `k3d` cluster named `iot-cluster`
* Installs Traefik (via Helm)
* Installs GitLab and GitLab Runner into separate namespaces
* Sets up port forwarding to access GitLab
* Retrieves the GitLab root password into `Password.txt`

---

### 🧹 Teardown

To delete everything created by the deployment:

```bash
chmod +x delete.sh
./delete.sh
```

This will:

* Uninstall Helm releases (GitLab, GitLab Runner, Traefik)
* Delete associated namespaces and CRDs
* Delete the `k3d` cluster

---

### 🌐 Access GitLab

After deploying and port-forwarding:

* Access GitLab: [http://localhost:8080](http://localhost:8080)
* GitLab root password: located in `Password.txt`

---

### 📦 CI/CD Pipeline

The `.gitlab-ci.yaml` file defines your GitLab CI/CD pipeline. This file should be added to your project repository inside GitLab.

---

### 📄 Notes

* The Helm values files (`gitlab-values.yaml`, `gitlab-runner-values.yaml`) should be tailored to your specific needs.
* Ensure ports `8080` and `8443` are available before deployment.
* You may need to modify the `kubectl port-forward` line to suit your access preferences (or use an Ingress/LoadBalancer setup).

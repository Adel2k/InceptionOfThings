#!/bin/bash

k apply -f namespace.yml
kubectl apply -f application.yaml
kubectl apply -f costum.yaml
kubectl apply -f deploy.yaml
kubectl apply -f service.yaml
kubectl apply -f .
kubectl get all
k3d cluster create iot-cluster --agents 2

# argocd login and port fprwarding
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d



k3d cluster create --config k3d-cluster.yaml
 kubectl config use-context k3d-iot-cluster
 k3d kubeconfig merge iot-cluster --kubeconfig-merge-default --kubeconfig-switch-context

kubectl port-forward svc/playground -n dev 8888:8888

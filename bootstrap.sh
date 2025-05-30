#!/bin/bash

set -e  # Stoppe le script en cas d'erreur

# Variables
RESOURCE_GROUP="RG-CYNA-PROD"
CLUSTER_NAME="ClusterWEB"
CLUSTER_ISSUER_FILE="cluster-issuer.yaml"

#Connexion au cluster AKS
echo "Connexion au cluster AKS : $CLUSTER_NAME dans $RESOURCE_GROUP"
az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME"

# Ajout des dépôts Helm
echo "Ajout des dépôts Helm..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Installation du Ingress Controller
echo "Installation de NGINX Ingress Controller..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.publishService.enabled=true \
  --wait

# Installation de cert-manager
echo "Installation de cert-manager..."
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --wait

# Déploiement du ClusterIssuer
echo "Déploiement du ClusterIssuer cert-manager..."
if [ -f "$CLUSTER_ISSUER_FILE" ]; then
  kubectl apply -f "$CLUSTER_ISSUER_FILE"
  echo "ClusterIssuer déployé."
else
  echo "Erreur : fichier '$CLUSTER_ISSUER_FILE' introuvable."
  exit 1
fi

echo "Ingress NGINX et cert-manager installés avec succès sur le cluster AKS."

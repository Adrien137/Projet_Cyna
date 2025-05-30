# 🛠️ Cyna – Exemples de Pipelines Azure DevOps

Ce dépôt contient une collection de pipelines YAML utilisés dans le cadre des projets DevOps de la société **Cyna**, notamment pour :

- Le déploiement sécurisé de l’infrastructure (Terraform, Ansible)
- La gestion d’un cluster Kubernetes AKS
- L’analyse de sécurité des workloads (kubeaudit, scanner de vulnérabilités)
- L’automatisation des artefacts de conformité

---

## Structure du dépôt


├── kubeaudit-pipeline.yml # Audit de sécurité Kubernetes avec publication JSON
├── aks-deploy.yml # Déploiement d'applications et de manifests sur AKS
├── terraform-deploy.yml # Déploiement d'infrastructure via Terraform
├── artifact-publish.yml # Pipeline générique pour la publication de fichiers
├── ci-cd-backend-dotnet.yml # CI/CD d’un backend .NET avec tests et sécurité
├── readme.md # Présentation du dépôt


---

## Pipelines principaux

### kubeaudit-pipeline.yml
Audit complet des pods AKS avec [kubeaudit](https://github.com/Shopify/kubeaudit) :

- Analyse des conteneurs (AppArmor, privilèges, runAsNonRoot, etc.)
- Génération d’un rapport `JSON` + version lisible en console
- Publication de l’artefact `kubeaudit-results.json`
- Résumé automatique (nb d’issues, par namespace/type)

Intégré dans le processus DevSecOps Cyna.

---

### aks-deploy.yml
Déploiement continu des services Cyna vers le cluster **AKS `ClusterWEB`** :

- Récupération des credentials via `az aks get-credentials`
- Application des manifests (`Deployment`, `Ingress`, `Service`)
- Validation post-déploiement via `kubectl get` + `describe` + `describe`

---

### terraform-deploy.yml
Automatisation du déploiement de l’infrastructure cloud hybride de Cyna :

- Initialisation et validation du code Terraform
- Application conditionnelle en `plan` ou `apply`
- Intégration avec des backends `AzureRM` pour le state

Peut inclure des scans de sécurité avec TFLint, Checkov ou tfsec.

---

### artifact-publish.yml
Exemple réutilisable pour publier des artefacts tels que :

- Rapports de scan de sécurité
- Configurations générées
- Export JSON ou YAML à destination du SOC ou des workflows ServiceNow

---

### ci-cd-backend-dotnet.yml
Pipeline d’intégration continue pour une application backend .NET :

- Compilation, tests unitaires, analyse SonarCloud
- Scan de sécurité des dépendances (Trivy)
- Publication automatique des binaires vers un artefact ou un registre

---

## Sécurité intégrée

| Outil | Objectif |
|-------|----------|
| `kubeaudit` | Audit sécurité des pods Kubernetes |
| `Trivy`     | Analyse des images Docker |
|  Sonarqube  | Analyse du code/couverture du code |
| `Azure DevOps` | Intégration avec Azure Monitor, Key Vault, et contrôle d’accès RBAC |

---

## Bonnes pratiques Cyna

- Les étapes critiques utilisent `continueOnError: true` pour ne pas bloquer la CI
- Les rapports sont toujours publiés même en cas d’échec (`condition: always()`)
- Chaque pipeline est structuré pour être **réutilisable et modulaire**

---

## Support

> Pour toute demande d’ajout, contribution ou assistance :
> Contactez l’équipe DevOps de Cyna via Teams ou ouvrez une **issue interne** dans le projet Azure DevOps.

---


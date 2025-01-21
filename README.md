# Infrastructure Terraform pour l'Application Kubernetes

Cette configuration Terraform déploie l'infrastructure nécessaire pour exécuter l'application sur AWS EKS.

## Composants

- **VPC** : Réseau isolé avec sous-réseaux publics et privés
- **EKS** : Cluster Kubernetes managé par AWS
- **ECR** : Registre pour stocker les images Docker

## Prérequis

1. AWS CLI configuré avec les credentials appropriés
2. Terraform v1.0 ou supérieur
3. kubectl installé
4. Un bucket S3 pour le stockage du state Terraform

## Structure des fichiers

```
terraform/
├── main.tf              # Configuration principale
├── variables.tf         # Définition des variables
├── outputs.tf           # Sorties
└── modules/
    ├── vpc/            # Module de configuration du VPC
    ├── eks/            # Module de configuration d'EKS
    └── ecr/            # Module de configuration d'ECR
```

## Utilisation

1. Initialiser Terraform :
```bash
terraform init
```

2. Vérifier le plan d'exécution :
```bash
terraform plan
```

3. Appliquer la configuration :
```bash
terraform apply
```

4. Une fois déployé, configurer kubectl :
```bash
aws eks update-kubeconfig --region eu-west-3 --name kubernetes-application
```

5. Pour pousser une image dans ECR :
```bash
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repository_url)
docker tag web-app:latest $(terraform output -raw ecr_repository_url):latest
docker push $(terraform output -raw ecr_repository_url):latest
```

## Variables

- `aws_region` : Région AWS (défaut: eu-west-3)
- `environment` : Environnement (défaut: production)
- `cluster_name` : Nom du cluster EKS (défaut: kubernetes-application)
- `vpc_cidr` : CIDR du VPC (défaut: 10.0.0.0/16)

## Notes importantes

1. Le cluster EKS est configuré avec des nœuds t3.medium
2. Le registre ECR conserve les 30 dernières images
3. Le VPC est configuré avec un NAT Gateway unique pour optimiser les coûts
4. L'accès public au cluster EKS est activé pour faciliter la gestion

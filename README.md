# Hylastix Keycloak Assignment

This repository deploys Keycloak IAM on Azure Cloud.
Repository contains Terraform which is used for creating Infrastructure on Azure alongside Ansible that will install all the neccessary services for Keycloak, Postgres DB that is attached to our Keycloak and Nginx that redirects user to Login page in order to access static web page.

![pipeline](https://github.com/user-attachments/assets/a64ae653-e78b-40e6-bdd0-310d5baa4311)


## Table of Contents
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Justify your choice](#justify-your-choice)
- [Potential Enhancements](#potential-enhancements)
- [Helpful links](#helpful-links)

## Architecture
The deployment architecture includes:
- Virtual Machine
- Virtual Network & Subnet
- Network Interface (NIC) & Public-IP
- Network Security Group (NSG) with ports: SSH (22), HTTP (80), HTTPS (443), and Keycloak (8443)
- Terraform Cloud for remote state files
- Ansible Vault to store secrets
- Nginx installed by package manager
- Docker compose container environment being run by Ansible that deploys:
  - Keycloak
  - PostgreSQL database
  - OAuth2
  
![azure_arch](https://github.com/user-attachments/assets/a1ef20b8-ebf3-4f7a-9968-8837b72ce9e8)


## Project Structure
```
├── .github/workflows
│   ├── deploy.yml
│   └── destroy.yml
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
└── ansible
    ├── group_vars
    │   └── all
    │       └── vault.yml
    ├── roles
    │   ├── nginx
    │   │    ├── files
    │   │    │   └── app.j2
    │   │    ├── handlers
    │   │    │   └── main.yml
    │   │    ├── tasks
    │   │    │   └── main.yml
    │   │    └── templates
    │   │        └── index.html
    │   ├── docker
    │   │   └── tasks
    │   │       └── main.yml
    │   └── keycloak
    │       ├── files
    │       │   └── docker-compose.yml.j2
    │       ├── tasks
    │       │   └── main.yml
    │       └── vars
    │           └── main.yml
    │
    └── playbook.yml
```

## Justify your choice


### Network Configuration:
NSG defined rules for opening necessary ports for SSH, HTTPS, and Keycloak service.

### VM Image:
Ubuntu 22.04 LTS - Long Term Support, not the latest version due to proven stability and bigger community due to being out a stable image for 3 years.  
Canonical - Trusted image.

## VM Size, Region
B2as_v2 - Budget-friendly option which has 2 vCPUS and 8GB of RAM which is enough power to run our services on it.  
Sweden Central - Chosen as its the cheapest EU Region in Azure.

### Deployment
GitHub Actions workflow **deploy.yml** :
- On Pull Request does terraform validate to check Terraform configuration files correctness. Syntax, Variables, Provider...
- On Pull Request does terraform plan to preview the changes before applying them.
- On Merge, does terraform apply to provision infrastructure , then uses Ansible to configure VM and install required services on that VM (based on IP from Terraform Output).
 
GitHub Actions workflow **destroy.yml** :
- On manual trigger, to avoid destruction of infrastructure by mistake. Triggers destroy pipeline that deletes all of the created infrastructure by Terraform.

### Secret Management
**Ansible Vault** was the choice, due to its simplicity, native integration with Ansible and no associated costs making it perfect for this assignment.

### Remote Backend
Used remote backend to securely store Terraform state files which is also good for enabling team collaboration, state locking, versioning, helps us prevent conflicts and ensures consistent, reliable infrastructure in multi-user or automated environments. 
My choice was **Terraform Cloud** beacuse of secure and out of the box experience as well as remote exectution of terraform apply.

### OAuth2
Standards-compliant authentication combined with Keycloak, modern, scalable and simplifies user management.

### Docker Images used:
quay.io/oauth2-proxy/oauth2-proxy - Documentation i was refering to was using this so i choose to follow the path.  
postgres:15 - Official Postgres Image and Stable Version that is compatible with Keycloak.  
quay.io/keycloak/keycloak:latest - Documentation on Keycloak suggested using this image so i went with the safest option.

## Potential Enhancements
- Replace self-signed certificates with certificates issued trusted CA such as Let’s Encrypt.This would improve security, ensure its trusted, and eliminate trust warnings in browser. 
- Replace Ansible Vault with HashiCorp Vault or Azure Key Vault for enhanced security, centralized access control—making it more suitable for production environment.
- GitHub Branch Protections, ensures not allowing pushing to master branch without reviewed and approved PR, passed tests on PR.
- Restricting NSG Rules so not everyone can access keycloak but employees
- Implement Monitoring and alerting for things like high CPU, Disk usage, downtime etc..
- Refactoring the Terraform code into modules for consistent, maintainable, and scalable deployments for multiple environments and landing zones.

## Helpful Links
https://www.keycloak.org/getting-started/getting-started-docker  
https://www.keycloak.org/documentation  
https://docs.ansible.com/ansible/latest/collections/community/general/keycloak_client_module.html



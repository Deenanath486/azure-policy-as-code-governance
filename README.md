# Azure Policy-as-Code (PaC) Security Guardrails 🛡️📋

[![Policy CI](https://github.com/Deenanath486/azure-policy-as-code-governance/actions/workflows/policy-ci.yml/badge.svg)](https://github.com/Deenanath486/azure-policy-as-code-governance/actions/workflows/policy-ci.yml)
[![Azure Policy](https://img.shields.io/badge/Azure_Policy-Governance-0078D4?style=flat&logo=microsoft-azure&logoColor=white)](https://learn.microsoft.com/en-us/azure/governance/policy/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![CAF Compliance](https://img.shields.io/badge/CAF-Compliant-success)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)

Production-grade **Azure Policy-as-Code (PaC)** framework enforcing security guardrails, regional data sovereignty, resource tagging governance, and storage compliance across enterprise Azure subscriptions aligned with the **Microsoft Cloud Adoption Framework (CAF)**.

---

## 🏛️ Policy-as-Code Architecture & Evaluation Model

```text
 ┌────────────────────────────────────────────────────────────────────────────────────────┐
 │                          AZURE RESOURCE MANAGER (ARM) REQUEST                          │
 └────────────────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                     [ Azure Policy Evaluation Engine ]
                                    │
    ┌───────────────────────────────┼───────────────────────────────┐
    │                               │                               │
    ▼                               ▼                               ▼
[ Policy: Deny Public IPs ]   [ Policy: Enforce Tags ]    [ Policy: Require TLS 1.2+ ]
(Blocks Internet Ingress)     (Owner, Env, CostCenter)    (Secure Data in Transit)
    │                               │                               │
    └───────────────────────────────┴───────────────────────────────┘
                                    │
                      ┌─────────────┴─────────────┐
                      ▼                           ▼
              [ COMPLIANT ]               [ NON-COMPLIANT ]
           Deployment Approved           Deployment Denied (403)
```

---

## 🔒 Policy Definitions & Initiatives Included

| Policy Name | Scope | Mode | Enforcement Effect |
| :--- | :--- | :--- | :--- |
| **Deny Public IP on NIC** | Network Interfaces | `All` | **Deny**: Blocks creation of public IPs on VMs to enforce private Bastion access. |
| **Enforce Mandatory Tags** | All Resources | `Indexed` | **Deny**: Rejects creation if `Environment`, `Owner`, or `CostCenter` tags are missing. |
| **Allowed Deployment Regions** | All Subscriptions | `Indexed` | **Deny**: Restricts workloads to approved regions (`centralindia`, `southindia`). |
| **Require Storage TLS 1.2+** | Storage Accounts | `Indexed` | **Deny**: Enforces `supportsHttpsTrafficOnly=true` and minimum `TLS1_2`. |
| **Enterprise Security Baseline**| **Policy Initiative (Set)** | `Set` | **Initiative**: Bundles all above policies into a single auditable baseline. |

---

## 📁 Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── policy-ci.yml           # Validates JSON schemas & Terraform syntax
├── policies/
│   └── custom/
│       ├── deny-public-ip-nic.json     # Denies public IP addresses on NICs
│       ├── enforce-mandatory-tags.json # Requires Environment, Owner, CostCenter
│       ├── restrict-locations.json     # Enforces data sovereignty regions
│       └── require-storage-tls12.json  # Enforces TLS 1.2+ on Azure Storage
├── infra/                              # Automation via Terraform
│   ├── providers.tf                    # AzureRM provider
│   └── main.tf                         # Custom Policy Definitions + Initiative Set
├── .gitignore
└── README.md
```

---

## 🚀 Deployment Guide (Terraform)

### 1. Validate Policy JSON Schemas Locally
```bash
jq . policies/custom/deny-public-ip-nic.json
jq . policies/custom/enforce-mandatory-tags.json
```

### 2. Deploy Policies & Initiatives
```bash
cd infra
terraform init
terraform plan
terraform apply
```

---

## 👨‍💻 Author

**Deenanath Yadav**  
*DevOps & Azure Cloud Engineer*  
- **LinkedIn**: [linkedin.com/in/deenanath-yadav-495110146](https://www.linkedin.com/in/deenanath-yadav-495110146)  
- **Email**: [deenanathyadav106@gmail.com](mailto:deenanathyadav106@gmail.com)

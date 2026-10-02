# Secure AWS CI/CD Pipeline with Terraform & OIDC

A production-grade, DevSecOps-aligned CI/CD pipeline built with Terraform, GitHub Actions, and AWS OpenID Connect (OIDC) authentication. This project demonstrates passwordless deployment of secure AWS infrastructure backed by automated vulnerability scanning and audit logging.

---

## 🏗️ Architecture Overview

```text
[ Developer ] ──> Push / PR ──> [ GitHub Actions ]
                                       │
                         1. Request JWT│2. Assume Role
                                       ▼
                             [ AWS STS (OIDC) ]
                                       │
                               3. Issue Temp Credentials
                                       ▼
                             [ Terraform Apply ]
                                       │
                                       ▼
                       [ AWS S3 Infrastructure ]

Key Security & Infrastructure Controls
Passwordless OIDC Authentication: Replaces static AWS access keys with short-lived STS tokens bound strictly to repository claims.
DevSecOps Gate (Trivy): Scans Infrastructure as Code (IaC) for misconfigurations and security vulnerabilities on every Pull Request before code can be merged.
Automated Continuous Deployment: Automatically triggers terraform apply -auto-approve upon merging compliant code into main.
Encrypted & Private S3 Storage: Enforces AES256 server-side encryption, versioning, and strict Public Access Blocks.
Audit Transparency: Logs all federated access and role assumption events in AWS CloudTrail for compliance auditing.

📁 Repository Structure
secure-aws-pipeline/
├── .github/
│   └── workflows/
│       ├── deploy.yml         # CD pipeline triggered on main branch pushes
│       └── pr-checks.yml      # CI pipeline for linting, validation & Trivy scanning
├── evidence/
│   ├── cloudtrail-audit-screenshot.png # CloudTrail event verification screenshot
│   └── cloudtrail-event.json # Raw AssumeRoleWithWebIdentity event log
└── terraform/
    ├── iam.tf                 # OIDC provider & IAM deployment role trust policies
    ├── outputs.tf             # Terraform outputs (S3 bucket ARN, IAM role ARN)
    ├── providers.tf           # AWS provider and region configurations
    └── s3.tf                  # Secure S3 bucket definition

🔒 Security & OIDC Authentication Flow
Rather than managing long-lived AWS_ACCESS_KEY_ID secrets, GitHub Actions authenticates directly to AWS STS using OpenID Connect (OIDC):
Token Generation: The runner requests a JSON Web Token (JWT) from GitHub's OIDC issuer.
Federated Verification: AWS STS validates the JWT against the IAM OpenID Connect Provider (token.actions.githubusercontent.com).
Role Assumption: STS verifies the subject claim condition matches repo:<github-username>/<repo-name>:* and returns temporary 1-hour credentials.

📊 Verification & Audit Evidence
The deployment authentication handshake was verified in AWS CloudTrail:
Event Name: AssumeRoleWithWebIdentity
Event Source: sts.amazonaws.com
Federated User Identity: Recorded with exact GitHub repository reference and commit ref.
Raw event logs and console proof are archived under the /evidence directory.

🚀 Local Development & Execution
Prerequisites
Terraform CLI ($\ge 1.5.0$)
AWS CLI
Git



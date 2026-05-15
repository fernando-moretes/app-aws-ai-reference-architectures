# Terraform skeleton — RAG with Bedrock + OpenSearch

This skeleton creates the **wiring** for the architecture, not a production module.

## What it creates

- S3 bucket for the corpus (with versioning).
- OpenSearch Serverless vector collection + data access policies.
- Bedrock Knowledge Base + data source pointing at the S3 prefix.
- Lambda orchestrator + IAM role granting `bedrock:RetrieveAndGenerate`.
- API Gateway REST API (no authorizer wired — you bring Cognito).

## What it deliberately omits

- VPC / subnets / endpoints — depends on your network model.
- Tags / naming — depends on your tagging strategy.
- Remote state backend — set it up under `terraform/`.
- IAM permission boundaries — depends on your governance model.
- CloudWatch alarms and dashboards — out of scope.

## Usage

```bash
terraform init
terraform plan -var="project=my-rag"
terraform apply -var="project=my-rag"
```

Adapt names, tags, and IAM before any real deployment.

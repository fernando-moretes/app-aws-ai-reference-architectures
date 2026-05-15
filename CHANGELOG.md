# Changelog

All notable changes to this project will be documented in this file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-05-15

### Added
- Six reference architectures, each with: problem statement, components, Mermaid diagram, key decisions (MADR-light), cost analysis at three scales, Well-Architected review, trade-offs, and a Terraform skeleton.
- Architectures:
  - 01 — RAG with Bedrock + OpenSearch Serverless
  - 02 — Multi-agent orchestration (Bedrock Agents + Step Functions)
  - 03 — Streaming AI inference (Lambda Function URL + SSE)
  - 04 — Event-driven AI processing (EventBridge + SQS + Lambda)
  - 05 — Fine-tuning pipeline (SageMaker + Step Functions)
  - 06 — Secure agentic system (Bedrock Agents + Guardrails + VPC)
- MkDocs Material documentation site with sync script that mirrors architecture READMEs into `docs/`.
- GitHub Actions: terraform fmt check, markdown lint, commit lint, docs deploy to GitHub Pages.
- Next.js 14 landing page with a visual catalog of the six architectures.

[Unreleased]: https://github.com/fernandofatech/aws-ai-reference-architectures/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/fernandofatech/aws-ai-reference-architectures/releases/tag/v0.1.0

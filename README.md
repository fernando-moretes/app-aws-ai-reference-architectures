<div align="center">

# aws-ai-reference-architectures

**Six production-shaped reference architectures for AI workloads on AWS — diagrams, key decisions, Terraform skeletons, cost analysis at three scales, and Well-Architected reviews.**

[![Docs](https://github.com/fernandofatech/aws-ai-reference-architectures/actions/workflows/docs.yml/badge.svg)](https://fernandofatech.github.io/aws-ai-reference-architectures/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Architectures](https://img.shields.io/badge/architectures-6-8b5cf6.svg)](#the-architectures)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-fa6673.svg)](https://www.conventionalcommits.org)

[Docs site](https://fernandofatech.github.io/aws-ai-reference-architectures/) ·
[Landing](https://aws-ai-reference-architectures.vercel.app) ·
[How to read these](#how-to-read-these) ·
[Architectures](#the-architectures)

</div>

---

## Why this exists

Most AI-on-AWS examples online are either *toy notebooks* (one file, no IaC, no security) or *200-page enterprise white papers* (impressive, unreadable). This repo sits in the middle: six **opinionated** reference architectures that are detailed enough to be useful for real designs, and concise enough to be read in 10 minutes each.

Every architecture answers the same questions:

1. **Problem** — what use case does this fit?
2. **Components** — what services and why?
3. **Diagram** — one Mermaid view.
4. **Decisions** — the 3–5 calls that matter (with rationale and alternatives).
5. **Cost** — rough monthly USD at S / M / L scales.
6. **Well-Architected** — the salient findings across all six pillars.
7. **Trade-offs** — when to use this, when NOT to.
8. **Terraform skeleton** — IaC starting point (not a full module, by design).

## The architectures

| # | Name | Pattern | Best for |
| --- | --- | --- | --- |
| 01 | [RAG with Bedrock + OpenSearch](architectures/01-rag-bedrock-opensearch/) | Retrieval-augmented generation | Internal Q&A over docs, knowledge bases |
| 02 | [Multi-agent orchestration](architectures/02-multi-agent-orchestration/) | Bedrock Agents + Step Functions | Long-running workflows that need durable state |
| 03 | [Streaming AI inference](architectures/03-streaming-ai-inference/) | API Gateway + Lambda + Bedrock streaming | Chat UIs with token-level streaming |
| 04 | [Event-driven AI processing](architectures/04-event-driven-ai-processing/) | EventBridge + SQS + Lambda + Bedrock | Async classification, enrichment, moderation |
| 05 | [Fine-tuning pipeline](architectures/05-fine-tuning-pipeline/) | SageMaker + S3 + MLflow | Custom models on top of foundation models |
| 06 | [Secure agentic system](architectures/06-secure-agentic-system/) | Bedrock Agents + Guardrails + VPC | Multi-tenant production agent with hard guardrails |

## How to read these

- **For shaping a new design:** read the relevant architecture end-to-end, then port the trade-offs section into your design doc.
- **For brownfield review:** open the Well-Architected section and compare with your existing setup.
- **For cost conversations:** the cost-analysis tables include three sizings (S/M/L) with the input assumptions spelled out.
- **For ADR inspiration:** the decisions in each arch follow the [MADR](https://adr.github.io/madr/) format — copy and adapt.

## What this repo is NOT

- Not a Terraform module library. The IaC is **skeleton** — it shows the resources and wiring, but each team will adapt names, tags, networking, IAM policies and remote state.
- Not exhaustive. Six patterns cover most workloads I see in practice; if yours doesn't fit, [open an issue](https://github.com/fernandofatech/aws-ai-reference-architectures/issues/new) with the use case.
- Not a replacement for the AWS Well-Architected Tool — use the formal Tool before any production launch.

## Repo layout

```
.
├── architectures/                   # one folder per reference
│   ├── 01-rag-bedrock-opensearch/
│   ├── 02-multi-agent-orchestration/
│   ├── 03-streaming-ai-inference/
│   ├── 04-event-driven-ai-processing/
│   ├── 05-fine-tuning-pipeline/
│   └── 06-secure-agentic-system/
├── docs/                            # MkDocs Material site (GitHub Pages)
├── frontend/                        # Next.js catalog page (Vercel)
└── .github/workflows/               # CI + docs deploy
```

## Contributing

Issues with new patterns or corrections to existing ones are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md). Conventional Commits are enforced.

## License

[MIT](LICENSE) © Fernando Francisco Azevedo

## Author

**Fernando Francisco Azevedo** — Solution Architect, AWS & AI focus.
[fernando@moretes.com](mailto:fernando@moretes.com) · [LinkedIn](https://www.linkedin.com/in/fernando-francisco-azevedo/) · [fernando.moretes.com](https://fernando.moretes.com)

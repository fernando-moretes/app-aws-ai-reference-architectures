# AWS AI Reference Architectures

> Six production-shaped reference architectures for AI workloads on AWS — diagrams, decisions, Terraform skeletons, cost analysis and Well-Architected reviews.

This is the doc site for [github.com/fernandofatech/aws-ai-reference-architectures](https://github.com/fernandofatech/aws-ai-reference-architectures). Every architecture answers the same questions in the same order, so you can compare designs at a glance.

## The architectures

| # | Architecture | Pattern | Best for |
| --- | --- | --- | --- |
| 01 | [RAG with Bedrock + OpenSearch](architectures/01-rag-bedrock-opensearch.md) | Retrieval-augmented generation | Internal Q&A over docs |
| 02 | [Multi-agent orchestration](architectures/02-multi-agent-orchestration.md) | Bedrock Agents + Step Functions | Long-running workflows |
| 03 | [Streaming AI inference](architectures/03-streaming-ai-inference.md) | API Gateway + Lambda streaming | Chat UIs with token streaming |
| 04 | [Event-driven AI processing](architectures/04-event-driven-ai-processing.md) | EventBridge + SQS + Lambda | Async classification & enrichment |
| 05 | [Fine-tuning pipeline](architectures/05-fine-tuning-pipeline.md) | SageMaker + S3 + MLflow | Custom models on top of FMs |
| 06 | [Secure agentic system](architectures/06-secure-agentic-system.md) | Bedrock Agents + Guardrails + VPC | Multi-tenant production agent |

Each page follows the same eight-section template. Read **just the trade-offs** if you are time-constrained — it's the section that tells you whether the pattern applies to *your* problem.

## Author

**Fernando Francisco Azevedo** — Solution Architect, AWS & AI focus.
[fernando@moretes.com](mailto:fernando@moretes.com) · [LinkedIn](https://www.linkedin.com/in/fernando-francisco-azevedo/) · [fernando.moretes.com](https://fernando.moretes.com)

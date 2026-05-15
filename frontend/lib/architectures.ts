export type Architecture = {
  id: string;
  number: string;
  title: string;
  pattern: string;
  summary: string;
  tags: string[];
  href: string;
  bestFor: string;
  scale: { s: string; m: string; l: string };
};

const REPO = "https://github.com/fernandofatech/aws-ai-reference-architectures/tree/main/architectures";

export const architectures: Architecture[] = [
  {
    id: "01-rag-bedrock-opensearch",
    number: "01",
    title: "RAG with Bedrock + OpenSearch",
    pattern: "Retrieval-augmented generation",
    summary:
      "Bedrock Knowledge Bases + OpenSearch Serverless vector store + S3 corpus. Synthesis with Claude, embeddings with Titan.",
    tags: ["Bedrock", "Knowledge Bases", "OpenSearch Serverless", "Cognito"],
    href: `${REPO}/01-rag-bedrock-opensearch`,
    bestFor: "Internal Q&A over docs, knowledge bases",
    scale: { s: "$430/mo", m: "$880/mo", l: "$3 100/mo" },
  },
  {
    id: "02-multi-agent-orchestration",
    number: "02",
    title: "Multi-agent orchestration",
    pattern: "Bedrock Agents + Step Functions",
    summary:
      "Durable, long-running workflows with specialized agents. Human-in-the-loop via waitForTaskToken.",
    tags: ["Bedrock Agents", "Step Functions", "DynamoDB", "Map"],
    href: `${REPO}/02-multi-agent-orchestration`,
    bestFor: "Workflows that exceed 15-min Lambda cap",
    scale: { s: "$120/mo", m: "$1 050/mo", l: "$8 200/mo" },
  },
  {
    id: "03-streaming-ai-inference",
    number: "03",
    title: "Streaming AI inference",
    pattern: "Lambda Function URL + SSE + Bedrock streaming",
    summary:
      "Token-level streaming from Bedrock to a browser chat UI. Sub-second time-to-first-token.",
    tags: ["Lambda streaming", "SSE", "CloudFront", "Cognito"],
    href: `${REPO}/03-streaming-ai-inference`,
    bestFor: "Chat UIs where TTFT matters",
    scale: { s: "$25/mo", m: "$640/mo", l: "$15 200/mo" },
  },
  {
    id: "04-event-driven-ai-processing",
    number: "04",
    title: "Event-driven AI processing",
    pattern: "EventBridge + SQS + Lambda + Bedrock",
    summary:
      "Async classification / enrichment / moderation at scale. Idempotency keys, DLQ, reserved concurrency.",
    tags: ["EventBridge", "SQS", "DynamoDB idempotency", "DLQ"],
    href: `${REPO}/04-event-driven-ai-processing`,
    bestFor: "Async pipelines with minutes-tolerant latency",
    scale: { s: "$80/mo", m: "$1 100/mo", l: "$28 000/mo" },
  },
  {
    id: "05-fine-tuning-pipeline",
    number: "05",
    title: "Fine-tuning pipeline",
    pattern: "SageMaker + S3 + Step Functions + MLflow",
    summary:
      "Reproducible custom-model pipeline with versioned datasets, eval gates, model registry approval, optional spot training.",
    tags: ["SageMaker", "Model Registry", "MLflow", "Glue"],
    href: `${REPO}/05-fine-tuning-pipeline`,
    bestFor: "Custom models when prompting + RAG aren't enough",
    scale: { s: "$120/mo", m: "$2 800/mo", l: "$22 000/mo" },
  },
  {
    id: "06-secure-agentic-system",
    number: "06",
    title: "Secure agentic system",
    pattern: "Bedrock Agents + Guardrails + VPC + kill switch",
    summary:
      "Multi-tenant agent with hard guardrails, network isolation, per-tenant IAM, SSM kill switch and per-tenant rate limits.",
    tags: ["Bedrock Agents", "Guardrails", "VPC", "WAF", "Kill switch"],
    href: `${REPO}/06-secure-agentic-system`,
    bestFor: "Production-grade multi-tenant agents",
    scale: { s: "$150/mo", m: "$2 100/mo", l: "$32 000/mo" },
  },
];

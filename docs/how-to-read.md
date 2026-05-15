# How to read these

Every architecture page is structured the same way. Skip to the section that matches what you came for.

## Eight sections per architecture

1. **Problem statement** — one paragraph. If this doesn't match your situation, the rest probably won't either.
2. **Components** — bullet list of services, each with a one-line *why*. Calibrates expectations.
3. **Diagram** — one Mermaid view.
4. **Decisions** — the 3–5 calls that shape the design. Each one has *Context*, *Decision*, *Alternatives*, *Consequences*. Steal the format for your own ADRs.
5. **Cost analysis** — three sizings (S / M / L). The input assumptions are always spelled out; if you disagree with an assumption, recompute.
6. **Well-Architected review** — short paragraphs per pillar. Treat as a checklist primer.
7. **Trade-offs** — "use this when..." and **"do NOT use this when..."**. The negative list is the most useful part of every page.
8. **Terraform skeleton** — link to a folder with `main.tf / variables.tf / outputs.tf` that wires resources. **Not production-ready** — naming, tags, IAM boundaries, state backend are all deliberately omitted.

## How to use the cost numbers

The numbers are us-east-1 on-demand approximations as of 2026-Q1. They are **not** quotes. For commercial commitments, use the AWS Pricing Calculator with your real assumptions.

The point of the S/M/L tables is to surface where the cost shifts proportionally and where it shifts non-linearly. If you double traffic, what doubles? What stays flat? What jumps to the next tier?

## How to use the Well-Architected sections

They are not exhaustive. They highlight the salient findings — the things that, in my experience, get missed during early shaping. For a real review, run the AWS Well-Architected Tool.

## How to use the Terraform

Read it. Don't run it. The skeletons are intentionally *unfinished* in places that depend on your org's conventions (tagging, IAM boundaries, networking, state backend). Forking and adapting is the intended workflow.

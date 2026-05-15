# Repository architecture

## Layout

This repo is **document-first**. The architectures live as Markdown with embedded Mermaid; the Terraform under each architecture is a *skeleton* (resources + wiring, no opinions on tags/IAM/state backends).

```
.
├── architectures/NN-name/   ← one folder per reference
│   ├── README.md            ← the architecture, end-to-end
│   ├── diagram.mmd          ← Mermaid source
│   └── terraform/           ← skeleton IaC
├── docs/                    ← MkDocs Material site (built from architectures/ + extras)
├── frontend/                ← Next.js catalog (Vercel)
└── .github/workflows/       ← CI + docs deploy
```

## Why "skeleton" Terraform

Production IaC carries opinions that don't generalize: tagging strategy, naming conventions, networking (VPC/subnets/peering), IAM boundaries, state backend, environment promotion. We deliberately stop **above** that line. The skeleton shows:

- The resources you will need (and which you typically won't).
- The wiring between them (dependencies, IAM grants, event sources).
- The minimum variable set to make the skeleton instantiate.

Teams fork the folder and bake their own opinions on top.

## Doc site

`mkdocs.yml` mounts `docs/` and every `architectures/*/README.md` into a single navigable site. The site is deployed to GitHub Pages on every push to `main` via the workflow in `.github/workflows/docs.yml`.

## Conventions

- Each architecture has a numeric prefix (`01-`, `02-`...) to fix display order.
- Every USD figure in cost tables is annotated with the input assumptions used to derive it. If you change the figure, change the assumption.
- Diagrams use **flowchart LR** unless the flow is fundamentally vertical (e.g. a pipeline with stages).

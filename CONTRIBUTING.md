# Contributing

## What good contributions look like

The most useful contributions are:

- **New architecture patterns** — submitted as a new folder under `architectures/NN-name/` following the structure of the existing six.
- **Corrections** to cost numbers, service behaviors, or Well-Architected findings.
- **Sharper trade-offs** sections — the "when NOT to use this" content is the hardest to write well.

Less useful (but still welcome):

- Typos and link fixes.
- Doc site styling tweaks.

## Workflow

Gitflow:

- `main` — published versions only, every release is tagged.
- `develop` — default integration branch; open PRs here.
- `feature/*` — short-lived branches off `develop`.

```bash
git checkout develop && git pull
git checkout -b feature/short-description
# ...changes...
git push -u origin feature/short-description
```

Open a PR **into `develop`**. Title must follow [Conventional Commits](https://www.conventionalcommits.org).

## Adding a new architecture

Each architecture lives in its own folder with this layout:

```text
architectures/NN-name/
├── README.md            # the entire architecture in one page
├── diagram.mmd          # Mermaid source
└── terraform/
    ├── README.md        # what the skeleton covers (and what it skips)
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

The README must include these sections, in this order:

1. **Problem statement** — one paragraph.
2. **Components** — bullet list with one-line rationale per service.
3. **Diagram** — embed the Mermaid inline.
4. **Decisions** — 3–5 numbered decisions in MADR-light style (Context / Decision / Alternatives / Consequences).
5. **Cost analysis** — table with at least three sizings, input assumptions spelled out.
6. **Well-Architected review** — bullet list per pillar.
7. **Trade-offs** — when to use this, when NOT to.

Keep prose tight. If a section exceeds ~250 words it probably wants splitting.

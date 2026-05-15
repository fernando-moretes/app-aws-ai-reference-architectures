# Operations

This repository follows a lightweight GitFlow:

- `develop` receives feature work.
- `main` receives release merges.
- Feature branches use `feature/<short-name>`.
- Commits follow Conventional Commits.

## GitHub Actions

| Workflow | Purpose |
| --- | --- |
| `Validate` | Terraform formatting, Markdown lint, Conventional Commit checks |
| `Frontend` | Static landing lint, build, and `npm audit` |
| `Deploy docs` | Strict MkDocs build and GitHub Pages deploy |
| `Security` | CodeQL, dependency review, Trivy, and Gitleaks |
| `Vercel` | Preview deploys for PRs and production deploys from `main` |

## Required GitHub secrets for Vercel

Configure these repository secrets before enabling automatic Vercel deployments:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

The workflow uses `vercel pull`, `vercel build`, and `vercel deploy --prebuilt` from the `frontend/` directory.

## Branch protection recommendation

Protect `main` and require these checks before merging:

- `Validate / terraform fmt`
- `Validate / markdown lint`
- `Frontend / Static frontend (lint, build, audit)`
- `Security / CodeQL`
- `Security / Trivy filesystem scan`
- `Security / Secret scan`

Require PR review and disallow direct pushes to `main` for normal work.

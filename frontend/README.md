# Catalog landing

Dependency-free static landing page rendering the six architectures as a card catalog. Each card links to the full architecture page on GitHub.

## Local development

```bash
cd frontend
npm run lint
npm run build
npm run dev
```

## Deploy on Vercel

The repo includes `.github/workflows/vercel.yml` for GitHub Actions based deploys.
Configure these repository secrets before enabling production deploys:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

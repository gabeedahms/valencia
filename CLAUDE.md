# Project Context

This is a website project deployed to Donweb hosting and versioned in GitHub.

## Tech Stack

- Frontend: [REPLACE: HTML/CSS/JS, React, Next.js, Astro, WordPress theme, PHP, etc.]
- Package manager: [npm/pnpm/yarn or none]
- Hosting: Donweb shared hosting
- Repository: GitHub is the source of truth

## Common Commands
- Check git changes: `git diff`

If a command does not exist in package.json, inspect package.json first and use the available equivalent.

## Workflow Rules

- Before editing, inspect the relevant files and explain the plan briefly.
- Prefer small, focused changes over broad rewrites.
- Do not modify deployment credentials, hosting config, `.env`, or secrets.
- Do not introduce new dependencies unless explicitly approved.
- After code changes, run the most relevant validation command.
- Always summarize modified files and why they changed.

## Code Style

- Keep existing project conventions.
- Prefer simple, maintainable code.
- Avoid over-engineering.
- Use semantic HTML where applicable.
- Prioritize responsive layout and accessibility.

## Design Rules

- Preserve current brand identity unless asked otherwise.
- Reuse existing CSS variables, components, classes, and layout patterns.
- Do not change global styles unless the task requires it.
- For visual changes, explain the expected UI impact.

## Deployment

- Use the project skill `/donweb-deploy` for production deployment to Donweb.
- Deployment must happen only from `master`, after changes are committed and pushed to GitHub.
- FTP configuration is stored in `.env.deploy` and must never be printed, edited, exposed, or committed.
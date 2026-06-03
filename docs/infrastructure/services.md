# Kyokai Infrastructure And Service Board

This document records the public service roles Kyokai plans to operate or publish. It is the deployed-service inventory and operational board, not a language spec. A service receives semantic, package, vulnerability, release, or execution authority only when an accepted D-point and spec section grant that authority.

> Trace: D514, D520, D524
> Covers: Official repositories and public services have recorded roles, owners, deployment boundaries, and authority classes; infrastructure deployment never creates language semantics.

## Service Roles

| Role | Authority Class | Initial Source | Status | Notes |
| --- | --- | --- | --- | --- |
| Main website | editorial | main monorepo `website/` | `PLANNED` | Public landing pages, news, showcase links, install pages. |
| Normative spec/docs | normative where sourced from `kyokaispec/` | main monorepo `kyokaispec/` | `PLANNED` | Rendered spec pages preserve spec authority. |
| Decided shape/governance | accepted-shape/workflow | `kyokaidecided.md`, `PROJECT_STANDARDS.md`, PRs/MRs | `PLANNED` | Public D-point and process trail. |
| Package index/search | derived discovery and docs index | `kyokai-package-index` metadata repo | `PLANNED` | Discovery metadata and compact docs-search projections over exact Git-hosted package revisions; not canonical source or docs storage. |
| Generated package docs | derived docs | published package-root `kdocs/` plus official structured renderer | `PLANNED` | Retrieves verified structured docs from exact indexed revisions through reviewed forge adapters. Kyokai does not require a package-doc artifact repository. |
| Playground/sandbox | interactive | sandbox runner service | `PLANNED` | Uses explicit runner contract, resource limits, and no ambient authority. |
| Advisories/security | security metadata | typed `kyokai-package-index` advisory subtree | `PLANNED` | Advisory authority follows accepted advisory records. |
| Releases/downloads | operational release | release workflow and artifacts | `PLANNED` | Publishes toolchain artifacts, checksum manifest, SBOMs, provenance, and explicit signing status. |
| Community/forum | support/pre-proposal | organization GitHub Discussions source repository | `PLANNED` | Not accepted shape or package trust. |
| Showcase | editorial | `kyokai-showcase` repo | `PLANNED` | Discovery only, no trust implication. |

> Trace: D506, D510, D513-D516, D519-D525
> Covers: Website, docs, index, playground, security, releases, community, and showcase services stay role-separated; derived and editorial services do not become source, trust, or semantic authorities.

## Required Service Record Fields

A role remains `PLANNED` until implementation work begins. When a role reaches `SCAFFOLDED`, replace its summary row with or link it to a complete per-service record.

Each active service record names:

- role
- repository or path
- owner
- deployment target
- source-of-truth input
- generated artifacts
- auth model
- secrets policy
- data retention policy
- privacy/logging policy
- cache policy
- backup/restore policy
- incident contact
- status
- relevant D-points

## Zero-Cost First Deployment Rule

Kyokai starts with static hosting and Git-reviewed metadata where possible. GitHub Pages, package-root committed `kdocs/`, compact package-index docs projections, PR/MR ownership review, signed commits, and checked generated artifacts are the default early shape. Custom login, database-backed package services, central package-doc storage, and hosted execution are added only when their authority, cost, privacy, and maintenance contracts are accepted.

> Trace: D513-D515, D520, D525
> Covers: Early deployment prefers reviewed static and Git-backed surfaces; a hosted or authenticated service requires an explicit service contract before deployment.

## Authority Boundary

Infrastructure status never decides language semantics. If a service needs to affect accepted Kyokai behavior, package trust, vulnerability authority, release authority, or execution authority, the service record links the accepted D-point and spec section that grant that role.

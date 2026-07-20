# Kyokai Infrastructure And Service Board

This document records the public service roles Kyokai plans to operate or publish. It is the deployed-service inventory and operational board, not a language spec. A service receives semantic, package, vulnerability, release, or execution authority only when an accepted D-point and spec section grant that authority.

> Trace: D514, D520, D524, D583, D624a
> Covers: Official repositories and public services have recorded roles, owners, deployment boundaries, and authority classes; infrastructure deployment never creates language semantics.

## Service Roles

| Role | Authority Class | Initial Source | Status | Notes |
| --- | --- | --- | --- | --- |
| Main website | editorial | main monorepo `website/` | `PLANNED` | Public landing pages, news, showcase links, install pages. |
| Normative spec/docs | normative where sourced from `kyokaispec/` | main monorepo `kyokaispec/` | `PLANNED` | Rendered spec pages preserve spec authority. |
| Decided shape/governance | accepted-shape/workflow | `kyokaidecided.md`, `PROJECT_STANDARDS.md`, PRs/MRs | `PLANNED` | Public D-point and process trail. |
| Knot/package index and search | derived discovery and docs index | planned ecosystem-index metadata repository; repository name pending | `PLANNED` | Knot-first main discovery plus a separate complete package section over exact Git-hosted revisions. Knot publication atomically records its selected packages; individual package publication remains supported. |
| Generated package and knot docs | derived docs | published package-root `kdocs/`, knot overview projections, and official structured renderer | `PLANNED` | Retrieves verified package docs and knot membership/dependency projections from exact indexed revisions through reviewed forge adapters. Kyokai does not require a central docs-artifact repository. |
| Playground/sandbox | interactive | sandbox runner service | `PLANNED` | Uses explicit runner contract, resource limits, and no ambient authority. |
| Private vulnerability intake and incident coordination | confidential security operations | `SECURITY.md`, repository private vulnerability reporting, and repository security advisories | `SETUP_PENDING` | D583 requires an honest `LIMITED_SINGLE_OWNER` state after setup. No operational intake, backup owner, 24/7 response, or paid SLA is claimed yet. |
| Public advisories/security metadata | derived public security metadata | disclosed repository security advisories plus typed knot-index advisory subtree | `PLANNED` | Public OSV/CSAF/index projections are derived from disclosed records and never become a second private case store. |
| Releases/downloads | operational release | release workflow and artifacts | `PLANNED` | Publishes toolchain artifacts, checksum manifest, SBOMs, provenance, and explicit signing status. |
| Community/forum | support/pre-proposal | organization GitHub Discussions source repository | `PLANNED` | Not accepted shape or package trust. |
| Showcase | editorial | `kyokai-showcase` repo | `PLANNED` | Discovery only, no trust implication. |

> Trace: D506, D510, D513-D516, D519-D525, D624a
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
- provider failure and account-recovery procedure
- embargo, coordinated-disclosure, revocation, and downstream-notification procedure when security-sensitive
- status
- relevant D-points

## Vulnerability-Service Bootstrap States

The private security service uses these public service-board states:

| State | Meaning |
| --- | --- |
| `SETUP_PENDING` | Accepted policy exists, but `SECURITY.md`, private reporting, advisory intake, owner record, or recovery checks are incomplete. No report channel is claimed operational. |
| `LIMITED_SINGLE_OWNER` | The named owner can receive and coordinate private reports through the configured provider. No backup owner, round-the-clock response, or resilience beyond the recorded provider and account recovery is claimed. |
| `OPERATIONAL_WITH_BACKUP` | A named backup/recovery owner, tested access recovery, retention/backup rules, and incident playbooks exist. This state still does not imply a paid SLA. |

Private case material remains in the configured provider unless an incident record authorizes an encrypted export. Reporter identity, exploit material, embargoed impact, and remediation discussion are not copied into public index metadata. Disclosure, rejection, duplication, closure, revocation, and incident-review outcomes publish only the information authorized for that case.

The service cannot leave `SETUP_PENDING` until the repository publishes `SECURITY.md`, enables private vulnerability reporting and advisories, names the actual owner, records account recovery outside the repository, and checks the reporting route. Tabletop exercises, compromised-key handling, malicious-package/index handling, cache poisoning, vulnerable release response, sandbox escape, secret leakage, and service compromise remain required operational work; accepting D583 did not perform them.

## Zero-Cost First Deployment Rule

Kyokai starts with static hosting and Git-reviewed metadata where possible. GitHub Pages, package-root committed `kdocs/`, compact package and knot projections, PR/MR ownership review, signed commits, and checked generated artifacts are the default early shape. Custom login, database-backed ecosystem services, central docs storage, and hosted execution are added only when their authority, cost, privacy, and maintenance contracts are accepted.

> Trace: D513-D515, D520, D525
> Covers: Early deployment prefers reviewed static and Git-backed surfaces; a hosted or authenticated service requires an explicit service contract before deployment.

## Public Visibility Ladder

Kyokai public visibility is staged. A public page, repository, package search surface, or release page states the highest stage it actually satisfies.

| Stage | Minimum service state | Public claim allowed |
| --- | --- | --- |
| `PUBLIC_EXPERIMENTAL` | Organization/repository ownership and at least the main website service record are `SCAFFOLDED` or better. | The project, roadmap, accepted shape, and infrastructure plan are public, but compiler conformance, package trust, stable install, and support are not claimed. |
| `PUBLIC_BOOTSTRAP` | Main website, normative docs route, releases/downloads route, community route, knot/package-index skeleton, docs-renderer skeleton, and service records are visible with bootstrap labels. | Readers can inspect docs, try explicitly labeled bootstrap artifacts, and review knot/package/index/docs shape. Publishing and docs verification remain incomplete unless their records say otherwise. |
| `PUBLIC_PACKAGE_ECOSYSTEM` | Package manager/index/docs/audit/vendoring/release service records are implemented for the advertised commands and routes. | External packages can be searched, documented, vendored, audited, and reproduced within recorded bootstrap authority. |
| `PUBLIC_CONFORMANCE_RELEASE` | Gate F in `phase.md` is closed. | The language surface is externally testable against spec, conformance, docs, stdlib admission records, package behavior, diagnostics, and release artifacts. |
| `PUBLIC_STABLE_PLATFORM` | Gate F is closed and the Phase 13 evidence exists for the named target/toolchain set. | Stable platform support can be claimed for those named C toolchains and targets only. |

Phase 13 C-toolchain admission is not a prerequisite for experimental public visibility. It is a prerequisite for stable platform claims.

## Authority Boundary

Infrastructure status never decides language semantics. If a service needs to affect accepted Kyokai behavior, package trust, vulnerability authority, release authority, or execution authority, the service record links the accepted D-point and spec section that grant that role.

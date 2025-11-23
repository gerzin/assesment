# Branching Strategy & Code Review Workflow

## Overview

This document outlines the branching strategy and pull request workflow. The description is very short as I didn't have much time to work on this but the flow is quite standard. I leave the detailed explanation of the decisions to the interview that will follow.

## Branching Strategy

### Core Branches

We employ a **GitFlow-inspired** strategy optimized for high-reliability software:

```
main (production)
  ↑
release/* (pre-deployment stabilization)
  ↑
develop (integration)
  ↑
feature/* (new development)
hotfix/* (critical fixes)
```

### Branch Descriptions

#### `main` - The Production Branch

The `main` branch represents what is actually running on production. Because of this, it's treated with extreme caution. Every commit on `main` should be deployable and has been thoroughly tested. We never commit directly to `main`—instead, changes arrive through carefully controlled merges from release branches or hotfixes.

When code lands on `main`, it receives a version tag (like `v1.2.3`) that allows us to track exactly what version is deployed where. This traceability is crucial when debugging issues across multiple vehicles or deployment environments.

The requirements for merging to `main` are stringent: all automated tests must pass, multiple senior engineers must review and approve the changes, and all codeowners must sign off. This isn't bureaucracy—it's recognition that mistakes here can have serious consequences.

#### `develop` - The Integration Branch

Think of `develop` as the ongoing integration environment. This is where features come together and it's discovered how they interact with each other. It's more stable than feature branches but less stable than `main`.

The `develop` branch allows to catch integration issues early, before we commit to a release. When feature branches are merged here, automated tests run immediately to detect problems. If `develop` breaks, the entire team stops and fixes it before moving forward. This discipline prevents the accumulation of technical debt and ensures developers always working from a known-good state.

Merging to `develop` requires at least 1/2 code review approval and all CI checks must pass.

#### `feature/*` - Development Branches

Feature branches are where individual developers or small teams work on specific enhancements. They're branched from `develop` and represent work-in-progress. The key to successful feature branches is keeping them small and short-lived.

The name must be descriptive (like `feature/onboard-telemetry` or `feature/ground-control-auth`) and optionally include user story IDs when working in an agile framework. This makes it easy to understand what work is happening in parallel. A link to the US can also be required in the description, and we can add CI checks to check that.

The philosophy here is "integrate early, integrate often." Rather than working in isolation for weeks, developers should aim to get their features reviewed and merged to `develop` within a few days. This reduces merge conflicts and ensures the team has visibility into everyone's work.

#### `release/*` - The Stabilization Phase

Release branches bridge the gap between the active development happening on `develop` and the production code on `main`.

Imagine `develop` as a stream that's constantly moving as new features are merged. If we deployed directly from `develop` to `main`, we'd be deploying code that might have been merged just hours ago, without adequate time for thorough validation. Release branches give us a "snapshot" that we can stabilize.

When we're ready to prepare a new release, we create a branch like `release/v1.2.0` from `develop`. At this point, a feature freeze goes into effect—no new features are added to this release branch. **Only bug fixes discovered during final testing are allowed**.

This stabilization period serves several purposes:

1. **Final Testing**: QA/V&V teams can perform comprehensive testing without sudden code changes beneath them. They test the exact code that will go to production.

2. **Documentation Finalization**: Technical writers can finalize release notes, API documentation, and user guides knowing the feature set won't change.

3. **Version Management**: We update version numbers in all the appropriate places (MODULE.bazel, pyproject.toml, etc.) to reflect the upcoming release.

4. **Risk Reduction**: By limiting changes to bug fixes only, we significantly reduce the risk of last-minute defects making it to production.

The release branch workflow looks like this:
- Create `release/v1.2.0` from `develop`
- Allow only critical bug fixes during the stabilization period
- Run extended test suites, performance benchmarks, and security audits
- Once stable, merge to `main` with a merge commit (preserving the release history)
- Tag the merge on `main` as `v1.2.0`
- Back-merge the release branch to `develop` to ensure any bug fixes are included in future work

#### `hotfix/*` - Emergency Fixes

Despite best efforts, critical bugs sometimes make it to production. Hotfix branches provide a fast way to fix these issues without waiting for the next planned release.

Hotfixes branch directly from `main` (not from `develop`) because we need to fix exactly what's in production, not what's being developed. Once the fix is ready and reviewed, it merges to both `main` and `develop` to ensure the bug doesn't resurface.

The process is expedited—reviews happen within hours, not days. Testing, reviews and CI are still required. We must have speed without sacrificing correctness.

# Security Policy

## Supported Versions

Proton-NV is an experimental project under active development. Security fixes
are applied to the `main` branch and the latest tagged release only.

| Version | Supported |
|---------|-----------|
| `main`  | Yes       |
| latest release | Yes |
| older releases | No |

## Reporting a Vulnerability

Please report security issues privately. **Do not open a public issue for
security vulnerabilities.**

1. Use GitHub's [private vulnerability reporting](https://github.com/ghostkellz/proton-NV/security/advisories/new)
   to open a draft advisory.
2. Include:
   - A description of the issue and its impact
   - Steps to reproduce or a proof of concept
   - Affected version(s) or commit hash
   - Any suggested remediation

You will receive an acknowledgement of the report. Once triaged, a fix and a
coordinated disclosure timeline will be agreed upon before any public details
are shared.

## Scope

Proton-NV is a build system that fetches upstream sources, applies patches, and
produces a Steam compatibility tool. Security-relevant areas include:

- **Upstream fetching** — the build clones Proton, DXVK, vkd3d-proton, and
  dxvk-nvapi from their upstream Git repositories (`Makefile.in`). Pinning to
  trusted commits/branches is the user's responsibility.
- **Patch application** — patches under `patches/` are applied to upstream trees
  before building. Review patches before trusting a build.
- **Build environment** — `configure.sh` and the generated `Makefile` run with
  the invoking user's privileges and write to `build/`, `dist/`, and
  `~/.local/share/Steam/compatibilitytools.d`.
- **Runtime configuration** — environment defaults in `proton-nv.conf` and any
  user overrides in `~/.config/proton-nv/`.

The compiled output is Proton/Wine itself; vulnerabilities in the upstream
projects should be reported to those projects directly.

## Dependency Security

- Repository security advisories are monitored by
  [Dependabot](https://github.com/ghostkellz/proton-NV/security/dependabot),
  with automated security update PRs enabled.
- Upstream components (Proton, DXVK, vkd3d-proton, dxvk-nvapi) are fetched at
  build time and are not tracked as repository dependencies; track their
  upstream security advisories separately.

# Contributing to Proton-NV

Thanks for your interest in improving Proton-NV. This document covers the
development setup, conventions, and how to submit changes.

> Proton-NV is experimental and under active development. Expect build options
> and patch sets to change.

## What Proton-NV Is

Proton-NV is **not** an application codebase — it is a build system. It fetches
upstream Proton, DXVK, vkd3d-proton, and dxvk-nvapi, applies NVIDIA-focused
patches, and packages the result as a Steam compatibility tool. Contributions
are mostly patches, build-system changes, and documentation.

## Prerequisites

On Arch/CachyOS:

```bash
sudo pacman -S base-devel git meson ninja mingw-w64-gcc wine glslang ccache vulkan-devel
```

For runtime testing you also need:

- An NVIDIA GPU with the Open Kernel Module driver (580+ minimum; 595+ for
  `VK_EXT_descriptor_heap`; 600/610 branches work as well)
- Steam, for installing and selecting the compatibility tool

## Building

```bash
./configure.sh            # generate the Makefile
make                      # fetch + patch + build + dist
make install              # install to ~/.local/share/Steam/compatibilitytools.d
make show-config          # print the resolved build configuration
```

See [docs/reference/build-options.md](docs/reference/build-options.md) for all
`configure.sh` flags and `make` targets.

## Working on Patches

Patches live under `patches/`, grouped by target tree:

- `patches/nvidia/` — NVIDIA driver / scheduler / descriptor-heap detection
- `patches/proton/` — Proton and Wine patches (GE/tkg-style)
- `patches/dxvk/` — DXVK patches
- `patches/vkd3d/` — vkd3d-proton patches (currently all in `deprecated/`)
- `patches/wine-hotfixes/` — targeted Wine hotfixes

Guidelines:

- Generate patches with `git format-patch` / `git diff -p` against the matching
  upstream tree under `upstream/` after `make fetch`.
- Keep numeric prefixes ordered and descriptive (e.g.
  `0007-vk-ext-descriptor-heap-detection.patch`).
- Each patch should apply cleanly with `patch -Np1`. The build reports any
  patch that fails to apply rather than aborting — verify your patch applies
  before submitting.
- Prefer upstreaming NVIDIA features to vkd3d-proton/DXVK directly; carry a
  patch here only while it is out-of-tree. Move superseded patches to a
  `deprecated/` directory rather than deleting their history.

## Coding / Shell Standards

- Keep `configure.sh` and `Makefile.in` POSIX/bash-portable and `set -e` safe.
- Explain *why* in comments, not *what*. Do not scatter version numbers through
  scripts, patches, or docs — versioning belongs in
  [CHANGELOG.md](CHANGELOG.md) and the build's `version` file.
- Keep changes minimal and focused; avoid unrelated reformatting.

## Commit Messages

Follow Conventional Commits:

```
feat: add RTX 50-series scheduler tuning patch
fix: correct descriptor_heap detection on 610 driver
docs: document benchmarking workflow
chore: bump default DXVK branch
```

## Pull Requests

1. Fork the repository and create a topic branch.
2. Make your change; verify the build still configures and patches cleanly.
3. Open a PR describing the change and its motivation. Include benchmark numbers
   for performance-related patches where practical (see
   [docs/guides/benchmarking.md](docs/guides/benchmarking.md)).

## Documentation

User-facing documentation lives in [`docs/`](docs/README.md). Keep it accurate
and organized:

- One index only: `docs/README.md`.
- Group new pages under `getting-started/`, `reference/`, `guides/`, or
  `internals/`.
- Use lowercase, descriptive, kebab-case filenames.
- Record notable changes in [`CHANGELOG.md`](CHANGELOG.md).

## Reporting Bugs and Requesting Features

Open an issue with your environment (GPU, driver branch, kernel, distro) and the
exact `configure.sh` options used. For security issues, follow
[SECURITY.md](SECURITY.md) instead.

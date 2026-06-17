# Proton-NV Documentation

Proton-NV is a custom Proton build tuned for NVIDIA GPUs on Linux. It fetches
upstream Proton, DXVK, vkd3d-proton, and dxvk-nvapi, applies NVIDIA-focused
patches, and packages the result as a Steam compatibility tool with sensible
NVIDIA defaults baked in.

It targets the NVIDIA Open Kernel Module driver (580+ minimum, 595+ for
`VK_EXT_descriptor_heap`, current 600/610 branches supported), RTX 40/50 series
GPUs, and CachyOS / Linux-tkg kernels on Linux 7.x.

> Experimental project under active development. Use at your own risk.

## Getting Started

- [Installation](getting-started/installation.md) — dependencies, building from source, packaging, and pre-built releases
- [Quickstart](getting-started/quickstart.md) — configure, build, install, and select Proton-NV in Steam
- [Configuration](getting-started/configuration.md) — `proton-nv.conf`, user overrides, and per-game launch options

## Reference

- [Build Options](reference/build-options.md) — every `configure.sh` flag and `make` target
- [Environment Variables](reference/environment-variables.md) — the `proton-nv.conf` defaults and what each one does

## Guides

- [Driver Support](guides/driver-support.md) — driver branches, `VK_EXT_descriptor_heap`, and the DX12 heap fix
- [Kernel Compatibility](guides/kernel-compatibility.md) — CachyOS/tkg/zen/mainline support and Linux 7.x
- [Steam Integration](guides/steam-integration.md) — installing, selecting, and per-game configuration
- [Benchmarking](guides/benchmarking.md) — measuring DX12 performance and A/B testing descriptor_heap

## Internals

- [Architecture](internals/architecture.md) — build-system layout and data flow
- [Patches](internals/patches.md) — the patch sets and how they are applied

## Project Info

- [Changelog](../CHANGELOG.md)
- [Contributing](../CONTRIBUTING.md)
- [Security Policy](../SECURITY.md)

## Related Projects

Proton-NV is part of the NVIDIA Linux gaming ecosystem:

- **nvproton** — per-game optimization profiles and launcher
- **nvshader** — shader cache management
- **nvlatency** — latency measurement and Reflex tuning
- **nvsync** — VRR / G-Sync control

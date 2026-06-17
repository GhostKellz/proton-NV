# Patches

Patches live under `patches/`, grouped by the upstream tree they target. The
`patch` stage applies them with `patch -Np1 --forward`, skipping any that are
already applied and reporting (but not aborting on) failures.

## How Patches Are Applied

For each set, `Makefile.in` iterates the `*.patch` files in order and applies
them in the matching upstream directory:

| Set | Applied in | Target |
|-----|-----------|--------|
| `patches/nvidia/` | `upstream/proton` | Proton tree (driver/scheduler/detection) |
| `patches/proton/` | `upstream/proton/wine` | Wine tree |
| `patches/wine-hotfixes/` | `upstream/proton/wine` | Wine tree |
| `patches/dxvk/` | `upstream/dxvk` | DXVK tree |
| `patches/vkd3d/` | `upstream/vkd3d-proton` | vkd3d-proton tree |

A patch that fails forward is retried as a reverse dry-run; if that succeeds it
is treated as already applied. Otherwise it is recorded and the build continues
with a warning so a single bad patch does not block the whole build.

## Patch Sets

### nvidia/

NVIDIA driver, scheduler, and feature-detection patches, e.g.:

- Open-driver optimizations
- CachyOS / tkg BORE scheduler tuning
- BORE+EEVDF gaming tuning and zen-kernel tuning
- RTX 50-series (Blackwell) optimizations
- `VK_NV_low_latency2` DXVK integration
- `VK_EXT_descriptor_heap` detection

### proton/

Proton- and Wine-level patches in the Proton-GE / wine-tkg tradition (FSR
fullscreen hack, kernel write-watch downgrade, WM-decoration switch, NV
low-latency Wine integration).

### dxvk/

DXVK integration patches (NVVK meson integration, device init, queue markers,
swapchain present path).

### vkd3d/

As of vkd3d-proton 3.0, the NVIDIA features Proton-NV used to patch in
(`VK_NV_low_latency2`, `VK_NV_raw_access_chains`, `VK_EXT_descriptor_buffer`) are
**upstream**, so there are no active vkd3d patches — the former ones live in
`patches/vkd3d/deprecated/` for reference. NVIDIA tuning is now done through
`VKD3D_CONFIG` instead (see
[Environment Variables](../reference/environment-variables.md)).

### wine-hotfixes/

Reserved for targeted, short-lived Wine hotfixes. May be empty between releases.

## Adding a Patch

1. `make fetch` to populate `upstream/`.
2. Make changes in the relevant `upstream/<component>` tree.
3. Generate the patch with `git diff -p` / `git format-patch`.
4. Drop it in the correct `patches/<set>/` directory with an ordered, descriptive
   `NNNN-name.patch` filename.
5. Re-run `make patch` and confirm it applies cleanly.

Prefer upstreaming a fix to vkd3d-proton / DXVK / Wine when possible; carry a
local patch only while it is out-of-tree, and move superseded patches to a
`deprecated/` directory rather than deleting them.

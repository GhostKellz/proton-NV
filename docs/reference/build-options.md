# Build Options

Proton-NV is configured with `configure.sh`, which generates a `Makefile` that
includes `Makefile.in`. This page documents the `configure.sh` flags, the `make`
targets, and the build-time variables.

## configure.sh

```bash
./configure.sh [OPTIONS]
```

| Flag | Default | Description |
|------|---------|-------------|
| `--build-name=NAME` | `Proton-NV` | Name used for the distribution and Steam display name |
| `--proton-commit=COMMIT` | `proton-experimental-bleeding-edge` | Proton upstream commit/branch |
| `--dxvk-commit=COMMIT` | `master` | DXVK commit/branch |
| `--vkd3d-commit=COMMIT` | `master` | vkd3d-proton commit/branch |
| `--container` | off | Build inside the SteamRT container image |
| `--no-ccache` | ccache on | Disable ccache |
| `--help`, `-h` | — | Show usage and exit |

### Environment variables read by configure.sh

| Variable | Default | Description |
|----------|---------|-------------|
| `BUILD_NAME` | `Proton-NV` | Same as `--build-name` |
| `PROTON_COMMIT` | `proton-experimental-bleeding-edge` | Proton ref |
| `WINE_COMMIT` | (unset) | Optional Wine ref |
| `DXVK_COMMIT` | `master` | DXVK ref |
| `VKD3D_COMMIT` | `master` | vkd3d-proton ref |
| `DXVK_NVAPI_COMMIT` | `master` | dxvk-nvapi ref |
| `STEAMRT_IMAGE` | `ghcr.io/open-wine-components/umu-sdk:latest` | Container image |
| `CONTAINER` | (unset) | Set to build in a container |
| `ENABLE_CCACHE` | `1` | Toggle ccache |

These values are written into the generated `Makefile` and consumed by
`Makefile.in`.

## make Targets

| Target | Description |
|--------|-------------|
| `all` (default) | `fetch` → `patch` → `build` → `dist` |
| `fetch` | Clone/update Proton, DXVK, vkd3d-proton, dxvk-nvapi into `upstream/` |
| `patch` | Apply all patch sets to the fetched trees |
| `build` | Compile Proton (which builds Wine, DXVK, vkd3d-proton, dxvk-nvapi) |
| `dist` | Package the build as a Steam compatibility tool in `dist/` |
| `install` | Copy the distribution to `~/.local/share/Steam/compatibilitytools.d/` |
| `clean` | Remove `build/` and `dist/`, reset patch/build stamps |
| `distclean` | `clean` plus remove `upstream/` and the generated `Makefile` |
| `dev` | Build against the vkd3d-proton descriptor-heap branch (PR #2805) |
| `fetch-dev` | Fetch only the vkd3d-proton descriptor-heap branch |
| `show-config` | Print the resolved build configuration |
| `help` | List targets |

## Upstream Sources

`make fetch` clones the following (shallow, by configured ref):

| Component | Upstream |
|-----------|----------|
| Proton | `github.com/ValveSoftware/Proton` |
| DXVK | `github.com/doitsujin/dxvk` |
| vkd3d-proton | `github.com/HansKristian-Work/vkd3d-proton` |
| dxvk-nvapi | `github.com/jp7677/dxvk-nvapi` |

Sources land under `upstream/`; build artifacts under `build/`; the packaged
tool under `dist/`.

## Compiler Flags

Set in `Makefile.in` and exported to sub-builds:

- `COMMON_CFLAGS`: `-O3 -march=x86-64-v3 -mtune=generic -fno-semantic-interposition -fipa-pta -fdevirtualize-at-ltrans -fno-plt -pipe`
- LTO: `-flto=auto` with CachyOS-style link flags
- NVIDIA defines: `-DNVIDIA_OPEN_DRIVER`, `-DVK_NV_LOW_LATENCY2_ENABLED=1`,
  `-DBAR1_AWARE_ALLOCATOR=1`, and a descriptor-heap toggle

> `-march=x86-64-v3` assumes an AVX2-capable CPU (typical for RTX 40/50 systems).
> Adjust in `Makefile.in` if you build for older hardware.

## NVIDIA / Target Settings

Fixed in `configure.sh` and surfaced to the build:

| Setting | Value | Meaning |
|---------|-------|---------|
| `NVIDIA_OPEN_DRIVER_MIN` | `580` | Minimum supported Open driver branch |
| `TARGET_GPU_ARCH` | `RTX40,RTX50` | Targeted GPU architectures |

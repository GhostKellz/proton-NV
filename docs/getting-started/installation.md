# Installation

There are three ways to get Proton-NV: build from source, build an Arch package
with the bundled `PKGBUILD`, or install a pre-built release.

## Requirements

- **GPU:** NVIDIA RTX 40 or 50 series (30 series may work)
- **Driver:** NVIDIA Open Kernel Module
  - 580+ minimum (no `VK_EXT_descriptor_heap`)
  - 595+ for the DX12 descriptor-heap path
  - 600 / 610 branches are supported and recommended
- **Kernel:** CachyOS, Linux-tkg, linux-zen, or mainline on Linux 7.x (6.19 also
  works). See [Kernel Compatibility](../guides/kernel-compatibility.md).
- **Steam:** for installing and selecting the compatibility tool

## Build Dependencies

On Arch / CachyOS:

```bash
sudo pacman -S base-devel git meson ninja mingw-w64-gcc wine glslang ccache vulkan-devel
```

A container-based build is also supported via `--container`, using the umu SDK
image (see [Build Options](../reference/build-options.md)).

## From Source

```bash
# Clone the repository
git clone https://github.com/ghostkellz/proton-NV.git
cd proton-NV

# Configure (generates the Makefile; optional flags customize the build)
./configure.sh

# Build: fetch upstream + apply patches + compile + package
make

# Install to your user Steam compatibility tools directory
make install
```

`make install` copies the build to
`~/.local/share/Steam/compatibilitytools.d/`. Restart Steam to pick it up.

The build is long: it compiles Proton/Wine, DXVK, vkd3d-proton, and dxvk-nvapi.
`ccache` is enabled by default to speed up rebuilds.

## Arch Package (makepkg)

The repository ships a `PKGBUILD` that runs `configure.sh` and `make`, then
installs to `/usr/share/steam/compatibilitytools.d/`:

```bash
makepkg -si
```

The package's post-install message explains how to make it visible to a per-user
Steam install if needed.

## Pre-built Releases

Download from [Releases](https://github.com/ghostkellz/proton-NV/releases) and
extract into your Steam compatibility tools directory:

```bash
mkdir -p ~/.local/share/Steam/compatibilitytools.d
tar -xf Proton-NV-*.tar.* -C ~/.local/share/Steam/compatibilitytools.d/
```

Restart Steam afterward.

## Next Steps

- [Quickstart](quickstart.md) — select Proton-NV and launch a game
- [Configuration](configuration.md) — tune the NVIDIA defaults

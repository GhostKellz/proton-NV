# Proton-NV

> **⚠️ Experimental Project** - This project is under active development and not fully tested. Use at your own risk.

**NVIDIA-Optimized Proton for Linux Gaming**

Proton-NV is a custom Proton build specifically tuned for NVIDIA GPUs on Linux, targeting:
- **NVIDIA Open Kernel Module 595+** with GSP=1 (595.45.04+ recommended)
- **vkd3d-proton 3.0** with NVIDIA-specific optimizations + VK_EXT_descriptor_heap
- **RTX 40/50 series GPUs**
- **CachyOS / Linux-tkg kernels with BORE+EEVDF scheduler**
- **Kernel 6.19+ / Linux 7.x gaming optimizations**

## Driver 595+ Benefits

Proton-NV 1.1 is optimized for NVIDIA 595.45.04+ which includes critical fixes:
- **VK_EXT_descriptor_heap** - Massive DX12 performance improvement via native descriptor heap support
- **Vulkan swapchain recreation performance** - Smoother alt-tab, resolution changes, and window resizing
- **Better VK_NV_low_latency2 behavior** - More reliable Reflex in DXVK/vkd3d-proton games
- **Wayland 1.20+ improvements** - Full functionality on KDE Plasma, GNOME, Hyprland
- **Linux 7.x kernel preparation** - Forward compatibility with upcoming kernel releases

## vkd3d-proton 3.0 Integration

Proton-NV targets vkd3d-proton 3.0 with NVIDIA-specific tuning:
- **force_static_cbv** - NVIDIA speed hack for constant buffer views (enabled by default)
- **VK_NV_low_latency2** - Native upstream Reflex support (NVIDIA contributed)
- **DXBC shader backend rewrite** - Better game compatibility
- **VK_EXT_descriptor_heap** - Enabled by default with NVIDIA 595+ (massive DX12 perf boost)

## Features

### NVIDIA Optimizations
- **VK_NV_low_latency2** - NVIDIA Reflex support for lower input latency
- **DXVK async shader compilation** - Reduces stuttering
- **NVAPI passthrough** - Full DLSS/Reflex/HDR support
- **BAR1-aware memory allocations** - Better VRAM utilization with Resizable BAR
- **RTX 50 series tuning** - Optimized for Blackwell architecture

### Scheduler Tuning
- **BORE+EEVDF detection** - Auto-detects CachyOS/tkg kernels
- **Gaming-optimized scheduler parameters** - Lower latency, better frame pacing
- **Per-game priority tuning** - Automatic nice/ionice for game processes

### Proton-GE Patches
- FSR (FidelityFX Super Resolution) upscaling
- VK_NV_low_latency2 Wine integration
- Game-specific fixes and hotfixes
- Staging patches for better compatibility

## Requirements

- **GPU**: NVIDIA RTX 40 or 50 series (30 series may work)
- **Driver**: NVIDIA Open Kernel Module
  - 580+ minimum (without descriptor heap)
  - 595+ for `VK_EXT_descriptor_heap`
  - 600 / 610 branches supported and recommended
- **Kernel**: CachyOS, Linux-tkg, linux-zen, or mainline on Linux 7.x (6.19 also supported)
- **Steam**: For automatic Proton integration

## Documentation

Full documentation lives in [`docs/`](docs/README.md):

- [Installation](docs/getting-started/installation.md) · [Quickstart](docs/getting-started/quickstart.md) · [Configuration](docs/getting-started/configuration.md)
- [Build Options](docs/reference/build-options.md) · [Environment Variables](docs/reference/environment-variables.md)
- [Driver Support](docs/guides/driver-support.md) · [Kernel Compatibility](docs/guides/kernel-compatibility.md) · [Steam Integration](docs/guides/steam-integration.md) · [Benchmarking](docs/guides/benchmarking.md)
- [Architecture](docs/internals/architecture.md) · [Patches](docs/internals/patches.md)

## Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/ghostkellz/proton-NV.git
cd proton-NV

# Configure (optional: customize build)
./configure.sh

# Build (this takes a while)
make

# Install to Steam
make install
```

### Pre-built Releases

Download from [Releases](https://github.com/ghostkellz/proton-NV/releases) and extract to:
```
~/.local/share/Steam/compatibilitytools.d/Proton-NV-X.X/
```

Restart Steam to see Proton-NV in the compatibility tools dropdown.

## Usage

### In Steam

1. Right-click a game -> Properties
2. Compatibility -> Force specific compatibility tool
3. Select **Proton-NV X.X**

### Environment Variables

Proton-NV respects these environment variables (set in Steam launch options):

```bash
# NVIDIA-specific
PROTON_ENABLE_NVAPI=1          # Enable NVAPI (default: 1)
PROTON_ENABLE_REFLEX=1         # Enable Reflex/low latency (default: 1)
DXVK_ASYNC=1                   # Async shader compilation (default: 1)

# Scheduler tuning
PROTON_NV_SCHEDULER_TUNING=1   # Auto-tune BORE/EEVDF (default: 1)
PROTON_NV_PERFORMANCE_GOVERNOR=1  # Set CPU to performance mode

# Sync primitives
PROTON_NO_ESYNC=0              # Use esync (default: enabled)
PROTON_NO_FSYNC=0              # Use fsync (default: enabled)

# Debug
PROTON_LOG=1                   # Enable Proton logging
DXVK_HUD=fps,frametimes        # Show DXVK HUD
```

## Configuration

### User Config

Create `~/.config/proton-nv/config` to override defaults:

```bash
# Example user config
DXVK_ASYNC=1
PROTON_ENABLE_REFLEX=1
PROTON_NV_SCHEDULER_TUNING=1
# DXVK_HUD=fps,frametimes,gpuload
```

### Per-Game Config

Use Steam launch options for per-game settings:
```
DXVK_ASYNC=1 PROTON_ENABLE_REFLEX=1 %command%
```

## Kernel Compatibility

| Kernel | Scheduler | Proton-NV Support | Notes |
|--------|-----------|-------------------|-------|
| **CachyOS 7.x** | BORE+EEVDF | Full | Recommended |
| Linux-tkg 7.x | BORE | Full | Recommended |
| Linux-zen 7.x | EEVDF | Full | GCC recommended for NVIDIA build |
| Mainline 7.x | EEVDF | Full | |
| CachyOS-lto 7.x | BORE+EEVDF | Full | |
| CachyOS / tkg 6.19 | BORE+EEVDF | Full | Still supported |
| Older (<6.19) | CFS/EEVDF | Basic | Missing newer mm/folio API |

### Linux 7.x

Linux 7.x is the current recommended target, paired with the NVIDIA Open Kernel
Module 600/610 branches that include the 7.x mm/folio and DRM updates. On a 7.x
kernel with a 610 Open driver you get the full Proton-NV feature set, including
the `VK_EXT_descriptor_heap` DX12 path. Kernel 6.19 remains fully supported.

See [docs/guides/kernel-compatibility.md](docs/guides/kernel-compatibility.md)
for details.

## Building

### Dependencies

On Arch/CachyOS:
```bash
sudo pacman -S base-devel git wine-staging vulkan-devel
```

### Build Options

```bash
# Configure with specific Proton version
./configure.sh --proton-commit=proton-10.0-rc

# Build without container
./configure.sh --no-container

# See all options
./configure.sh --help
```

## Directory Structure

```
proton-nv/
├── configure.sh          # Build configuration
├── Makefile.in           # Build rules
├── proton                 # Main launcher script
├── proton-nv.conf        # Default configuration
├── patches/
│   ├── proton/           # Proton/Wine patches (GE-style)
│   ├── nvidia/           # NVIDIA-specific patches
│   ├── dxvk/             # DXVK patches
│   └── vkd3d/            # vkd3d-proton patches
└── archive/              # Reference implementations
```

## Related Projects

Proton-NV is part of the NVIDIA Linux Gaming ecosystem:

- **nvproton** - Per-game optimization profiles
- **nvshader** - Shader cache management
- **nvlatency** - Latency measurement and tuning
- **nvsync** - VRR/G-Sync control
- **GhostVK** - Vulkan runtime layer
- **Rift** - Game management TUI

## License

Based on Valve's Proton (BSD-3-Clause) with additional patches from:
- [Proton-GE](https://github.com/GloriousEggroll/proton-ge-custom)
- [Wine-tkg](https://github.com/Frogging-Family/wine-tkg-git)

## Credits

- Valve for Proton
- GloriousEggroll for Proton-GE patches
- Frogging-Family for wine-tkg
- CachyOS team for kernel optimizations
- NVIDIA for open kernel module

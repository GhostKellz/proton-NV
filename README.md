# Proton-NV

**NVIDIA-Optimized Proton for Linux Gaming**

Proton-NV is a custom Proton build specifically tuned for NVIDIA GPUs on Linux, targeting:
- **NVIDIA Open Kernel Module 590+** with GSP=1 (590.xx recommended)
- **RTX 40/50 series GPUs**
- **CachyOS / Linux-tkg kernels with BORE+EEVDF scheduler**
- **Kernel 6.17/6.18+ gaming optimizations**

## Driver 590+ Benefits

Proton-NV 1.1 is optimized for NVIDIA 590.48.01+ which includes critical fixes:
- **Vulkan swapchain recreation performance** - Smoother alt-tab, resolution changes, and window resizing
- **Better VK_NV_low_latency2 behavior** - More reliable Reflex in DXVK games
- **Wayland 1.20+ improvements** - Full functionality on KDE Plasma, GNOME, Hyprland

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
- **Driver**: NVIDIA Open Kernel Module 590+ recommended (590.48.01+)
  - Minimum: 580+ (basic functionality)
- **Kernel**: CachyOS 6.6+, Linux-tkg 6.8+, or mainline 6.17+
- **Steam**: For automatic Proton integration

## Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/your-org/proton-nv.git
cd proton-nv

# Configure (optional: customize build)
./configure.sh

# Build (this takes a while)
make

# Install to Steam
make install
```

### Pre-built Releases

Download from [Releases](https://github.com/ghostkellz/proton-nv/releases) and extract to:
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

| Kernel | Scheduler | Proton-NV Support |
|--------|-----------|-------------------|
| CachyOS 6.6+ | BORE+EEVDF | Full |
| Linux-tkg 6.8+ | BORE | Full |
| Mainline 6.6+ | EEVDF | Good |
| Mainline 6.17/6.18 | EEVDF | Optimal |
| Older (<6.6) | CFS | Basic |

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

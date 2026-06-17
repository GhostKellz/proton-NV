# Configuration

Proton-NV ships a set of NVIDIA-focused defaults that are applied automatically
when you select it in Steam. You can override them globally or per game.

## Where Settings Come From

Settings are resolved in increasing order of precedence:

1. **`proton-nv.conf`** — the build's baked-in defaults, copied into the
   distribution under `proton-nv/`.
2. **User config** — `~/.config/proton-nv/config`, for machine-wide overrides.
3. **Steam launch options** — per-game overrides, highest precedence.

## Defaults

The full annotated default set lives in `proton-nv.conf`. Highlights:

| Variable | Default | Purpose |
|----------|---------|---------|
| `DXVK_ASYNC` | `1` | Async shader compilation (reduces stutter) |
| `DXVK_NVAPI` | `1` | NVAPI passthrough for DXVK |
| `VKD3D_CONFIG` | `force_static_cbv,descriptor_heap` | NVIDIA CBV speed hack + DX12 heap path |
| `VKD3D_DISABLE_DESCRIPTOR_QA` | `1` | Drops descriptor QA checks for performance |
| `PROTON_ENABLE_NVAPI` | `1` | Enable NVAPI in Proton |
| `PROTON_ENABLE_REFLEX` | `1` | Enable `VK_NV_low_latency2` (Reflex) |
| `PROTON_FORCE_LARGE_ADDRESS_AWARE` | `1` | LAA for 32-bit games needing >2 GB |
| `PROTON_BAR1_AWARE` | `1` | BAR1-aware allocation for RTX 40/50 |
| `__GL_THREADED_OPTIMIZATIONS` | `1` | NVIDIA threaded GL optimization |
| `__GL_SHADER_DISK_CACHE` | `1` | Persistent NVIDIA shader cache |
| `__GL_VRR_ALLOWED` | `1` | Allow VRR / G-Sync |

See [Environment Variables](../reference/environment-variables.md) for the
complete list and notes on each.

> `descriptor_heap` in `VKD3D_CONFIG` only takes effect on a driver that exposes
> `VK_EXT_descriptor_heap` (595+ / 600 / 610). On older drivers vkd3d-proton
> ignores it and uses the legacy path. See
> [Driver Support](../guides/driver-support.md).

## User Config

Create `~/.config/proton-nv/config` to override defaults system-wide:

```bash
# Example user config
DXVK_ASYNC=1
PROTON_ENABLE_REFLEX=1
# DXVK_HUD=fps,frametimes,gpuload
```

## Per-Game Overrides

Use Steam launch options for a single game (these win over everything else):

```
DXVK_HUD=fps,frametimes VKD3D_CONFIG=force_static_cbv %command%
```

To disable a default for a problematic title, unset or override it the same way,
for example dropping `descriptor_heap` if you suspect a regression:

```
VKD3D_CONFIG=force_static_cbv %command%
```

## Debugging

The following are off by default; enable per game when diagnosing:

```
PROTON_LOG=1 DXVK_HUD=full %command%
```

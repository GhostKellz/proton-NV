# Environment Variables

These variables are set as defaults in `proton-nv.conf` and applied when
Proton-NV runs. Any of them can be overridden in `~/.config/proton-nv/config`
or per game in Steam launch options. Commented-out entries in `proton-nv.conf`
are documented here as optional.

## DXVK (DX9/10/11 → Vulkan)

| Variable | Default | Description |
|----------|---------|-------------|
| `DXVK_ASYNC` | `1` | Async shader compilation; reduces stutter |
| `DXVK_NVAPI` | `1` | Enable NVAPI path in DXVK |
| `DXVK_FRAME_RATE` | `0` | Frame cap (`0` = unlimited) |
| `DXVK_STATE_CACHE_PATH` | (optional) | Override the DXVK state cache location |
| `DXVK_HUD` | (optional) | Overlay, e.g. `fps,frametimes,gpuload` |

## vkd3d-proton (DX12 → Vulkan)

| Variable | Default | Description |
|----------|---------|-------------|
| `VKD3D_CONFIG` | `force_static_cbv,descriptor_heap` | `force_static_cbv` is the NVIDIA CBV speed hack; `descriptor_heap` enables the DX12 heap path on capable drivers |
| `VKD3D_DISABLE_DESCRIPTOR_QA` | `1` | Disable descriptor QA checks for performance |
| `VKD3D_SHADER_CACHE_PATH` | (optional) | Override the vkd3d-proton shader cache |
| `VKD3D_DEBUG` | (optional) | vkd3d-proton log level |

> `descriptor_heap` requires a driver exposing `VK_EXT_descriptor_heap`
> (595 / 600 / 610). On older drivers it is ignored. See
> [Driver Support](../guides/driver-support.md).

## NVIDIA Reflex / Low Latency

| Variable | Default | Description |
|----------|---------|-------------|
| `PROTON_ENABLE_NVAPI` | `1` | Enable NVAPI in Proton |
| `DXVK_ENABLE_NVAPI` | `1` | Enable NVAPI in DXVK |
| `PROTON_ENABLE_REFLEX` | `1` | Enable `VK_NV_low_latency2` (needs game support) |

## Wine / Proton

| Variable | Default | Description |
|----------|---------|-------------|
| `PROTON_NO_ESYNC` | `0` | `0` keeps esync enabled |
| `PROTON_NO_FSYNC` | `0` | `0` keeps fsync enabled |
| `PROTON_FORCE_LARGE_ADDRESS_AWARE` | `1` | LAA for 32-bit games needing >2 GB |
| `PROTON_HIDE_NVIDIA_GPU` | `0` | Keep the NVIDIA GPU visible to games |
| `PROTON_USE_GAMEMODE` | (optional) | Integrate with Feral GameMode if installed |

## NVIDIA Open Driver Tuning

| Variable | Default | Description |
|----------|---------|-------------|
| `__GL_YIELD` | `USLEEP` | GL yield strategy |
| `__GL_THREADED_OPTIMIZATIONS` | `1` | Threaded GL optimization |
| `__GL_SHADER_DISK_CACHE` | `1` | Persistent shader disk cache |
| `__GL_SHADER_DISK_CACHE_SKIP_CLEANUP` | `1` | Don't auto-prune the shader cache |
| `__GL_VRR_ALLOWED` | `1` | Allow VRR / G-Sync |
| `VK_LAYER_NV_optimus` | `NVIDIA_only` | Force the NVIDIA GPU on Optimus systems |

## Memory

| Variable | Default | Description |
|----------|---------|-------------|
| `PROTON_BAR1_AWARE` | `1` | BAR1-aware allocation for RTX 40/50 (Resizable BAR) |
| `PROTON_USE_LARGE_PAGES` | (optional) | Large pages; requires system config |

## Scheduler (CachyOS / Linux-tkg BORE)

These are commented out by default; enable as needed:

| Variable | Description |
|----------|-------------|
| `PROTON_NICE` | Game-thread nice value (e.g. `-5`) |
| `PROTON_CPU_AFFINITY` | Pin to specific cores (e.g. `0-7`) |
| `PROTON_DISABLE_CPU_SCALING` | Disable frequency scaling while gaming (root) |

## Debugging

Off by default; enable per game:

| Variable | Description |
|----------|-------------|
| `PROTON_LOG` | Enable Proton logging |
| `PROTON_DUMP_DEBUG_COMMANDS` | Dump debug commands |
| `WINEDEBUG` | Wine debug channels, e.g. `-all` |

# Driver Support

Proton-NV's DX12 optimizations depend on Vulkan extensions that NVIDIA's Open
Kernel Module driver exposes. Detection is by **extension availability**, not a
hard version check, so newer driver branches keep working.

## Driver Branches

| Branch | Status | What you get |
|--------|--------|--------------|
| < 580 | Unsupported | — |
| 580+ | Minimum (`NVIDIA_OPEN_DRIVER_MIN`) | Builds and runs; no descriptor-heap path |
| 595+ | DX12 heap fix floor | `VK_EXT_descriptor_heap`, improved swapchain recreation, more reliable `VK_NV_low_latency2` |
| 600 / 610 | Current, recommended | Full feature set; this is what Proton-NV targets today |

The 595 branch first shipped the DX12 heap-fix extension set; the 600 and 610
production branches carry it forward. There is no need to stay on 595 — current
610 Open Kernel Module drivers are the recommended target.

## Key Extensions

| Extension | Purpose |
|-----------|---------|
| `VK_EXT_descriptor_heap` | Native DX12 descriptor heap — large DX12 perf uplift via vkd3d-proton |
| `VK_NV_low_latency2` | NVIDIA Reflex (low-latency) |
| `VK_NV_raw_access_chains` | Shader access optimization (upstream in vkd3d-proton) |
| `VK_EXT_descriptor_buffer` | Fallback descriptor path |

## vkd3d-proton and descriptor_heap

The driver extension is only half the story — vkd3d-proton must consume it.
Proton-NV builds vkd3d-proton 3.0+ where the NVIDIA features (Reflex,
raw_access_chains, descriptor_buffer) are upstream, and sets

```
VKD3D_CONFIG=force_static_cbv,descriptor_heap
```

by default. On a driver without `VK_EXT_descriptor_heap`, vkd3d-proton ignores
the `descriptor_heap` token and uses the legacy path, so the same build works
across driver branches.

To test the bleeding-edge descriptor-heap branch (vkd3d-proton PR #2805) before
it lands in a tagged release:

```bash
make dev
```

## Checking Your Driver

```bash
# Driver version / branch
cat /proc/driver/nvidia/version

# Whether the descriptor-heap extension is present
vulkaninfo | grep -i descriptor_heap
```

If you also use **nvproton**, `nvproton status` reports the driver branch, the
DX12 extensions present, and whether vkd3d-proton advertises descriptor-heap
support.

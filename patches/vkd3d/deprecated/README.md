# Deprecated vkd3d-proton Patches

These patches were removed in Proton-NV 1.1 because they are now **upstream in vkd3d-proton 3.0**.

## Why Removed

vkd3d-proton 2.12 (March 2024) added native VK_NV_low_latency2 support, contributed by NVIDIA.
vkd3d-proton 3.0 (November 2025) further improved this implementation.

Our custom nvvk wrapper patches are no longer needed - the upstream implementation is better maintained and tested.

## Removed Patches

| Patch | Reason |
|-------|--------|
| 0001-nvvk-meson-integration.patch | Native VK_NV_low_latency2 in vkd3d 2.12+ |
| 0002-vkd3d-nvvk-context.patch | Native implementation upstream |
| 0003-d3d12-command-queue.patch | Latency markers native in 2.12+ |
| 0004-d3d12-execute-indirect.patch | Out-of-band markers native |
| 0005-dxgi-present.patch | Present markers native |

## If You Need Custom Latency Tuning

Use environment variables instead:

```bash
# Enable Reflex (on by default with NVIDIA)
PROTON_ENABLE_NVAPI=1

# vkd3d-proton 3.0 config
VKD3D_CONFIG=force_static_cbv
```

## References

- vkd3d-proton 2.12 release: https://github.com/HansKristian-Work/vkd3d-proton/releases/tag/v2.12
- NVIDIA Reflex contribution: Native VK_NV_low_latency2 support
- vkd3d-proton 3.0 release: https://github.com/HansKristian-Work/vkd3d-proton/releases/tag/v3.0

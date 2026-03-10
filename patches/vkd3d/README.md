# vkd3d-proton Patches

## Current Status: Proton-NV 1.1 / vkd3d-proton 3.0

As of vkd3d-proton 3.0, most NVIDIA-specific features are **upstream**:

- VK_NV_low_latency2 (Reflex) - Native since 2.12
- VK_NV_raw_access_chains - Native since 2.12
- VK_EXT_descriptor_buffer - Native since 2.8
- DXBC shader backend rewrite - New in 3.0

## Active Patches

None currently. All previous patches moved to `deprecated/`.

## Configuration (No Patches Needed)

NVIDIA optimizations are now via environment variables:

```bash
# NVIDIA speed hack for constant buffers (vkd3d-proton 3.0)
VKD3D_CONFIG=force_static_cbv

# Disable descriptor QA for performance
VKD3D_DISABLE_DESCRIPTOR_QA=1

# Future: When VK_EXT_descriptor_heap is available (driver 595+)
# VKD3D_CONFIG=force_static_cbv,descriptor_heap
```

## Future: VK_EXT_descriptor_heap

Tracking: https://github.com/HansKristian-Work/vkd3d-proton/pull/2805

When NVIDIA 595+ releases with VK_EXT_descriptor_heap:
1. PR #2805 will be merged to vkd3d-proton
2. Add `descriptor_heap` to VKD3D_CONFIG
3. Massive DX12 performance improvement expected

Use `make dev` to test with PR #2805 branch when you have the beta driver.

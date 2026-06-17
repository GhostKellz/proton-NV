# Kernel Compatibility

Proton-NV targets modern gaming kernels and is tuned for the BORE+EEVDF
scheduler used by CachyOS and Linux-tkg. The scheduler-tuning patches under
`patches/nvidia/` auto-detect BORE/EEVDF kernels.

## Support Matrix

| Kernel | Scheduler | Support | Notes |
|--------|-----------|---------|-------|
| CachyOS 7.x | BORE+EEVDF | Full | Recommended |
| Linux-tkg 7.x | BORE | Full | Recommended |
| Linux-zen 7.x | EEVDF | Full | GCC recommended for the NVIDIA build |
| Mainline 7.x | EEVDF | Full | |
| CachyOS / tkg 6.19 | BORE+EEVDF | Full | Still supported |
| CachyOS-lto | BORE+EEVDF | Full | Current builds work; older Clang/LTO toolchains had NVIDIA build issues |
| Older (< 6.19) | CFS/EEVDF | Basic | Missing newer mm/folio APIs |

## Linux 7.x

Linux 7.x is the current recommended target. It pairs with the NVIDIA Open
Kernel Module 600/610 branches, which include the mm/folio and DRM updates the
7.x series introduced. On a 7.x kernel with a 610 Open driver you get the full
Proton-NV feature set, including the `VK_EXT_descriptor_heap` DX12 path.

If you are still on a 6.19 kernel, that remains fully supported — but the 7.x +
610 combination is what Proton-NV is tuned for now.

## Scheduler Tuning

When a BORE/EEVDF kernel is detected, the NVIDIA scheduler-tuning patches adjust
parameters for lower latency and steadier frame pacing. Per-game priority hints
(`PROTON_NICE`) and CPU affinity (`PROTON_CPU_AFFINITY`) can be set in
`proton-nv.conf` or Steam launch options — see
[Environment Variables](../reference/environment-variables.md).

## Build Toolchain Note

For the NVIDIA-focused build, GCC is the most reliable toolchain across zen and
mainline kernels. The build defaults assume an AVX2-capable CPU
(`-march=x86-64-v3`); adjust `Makefile.in` for older hardware.

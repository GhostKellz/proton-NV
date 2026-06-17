# Quickstart

This walks through building Proton-NV and using it for a game. It assumes the
[build dependencies](installation.md#build-dependencies) are installed.

## 1. Configure

```bash
./configure.sh
```

This generates a `Makefile` from `Makefile.in` with your chosen options. Run
`./configure.sh --help` to see all flags, or check the resolved configuration at
any time:

```bash
make show-config
```

## 2. Build

```bash
make
```

This runs the full pipeline: `fetch` (clone upstream sources) → `patch` (apply
the `patches/` sets) → `build` (compile) → `dist` (package as a Steam tool). The
output lands in `dist/Proton-NV-<version>-<date>/`.

To build against the bleeding-edge vkd3d-proton descriptor-heap branch instead,
use `make dev` (requires a 595+ / Vulkan-beta driver).

## 3. Install

```bash
make install
```

Copies the distribution to `~/.local/share/Steam/compatibilitytools.d/`.

## 4. Select in Steam

1. Restart Steam.
2. Right-click a game → **Properties**.
3. **Compatibility** → **Force the use of a specific Steam Play compatibility
   tool**.
4. Choose **Proton-NV** from the dropdown.

Launch the game. The NVIDIA defaults from `proton-nv.conf` (async DXVK, Reflex,
`force_static_cbv`, descriptor-heap when the driver supports it) are applied
automatically.

## 5. Verify

To confirm the DX12 descriptor-heap path is active on your driver, see the
[benchmarking guide](../guides/benchmarking.md) and
[driver support](../guides/driver-support.md).

## Next Steps

- [Configuration](configuration.md) — override defaults globally or per game
- [Steam Integration](../guides/steam-integration.md) — launch options and tips

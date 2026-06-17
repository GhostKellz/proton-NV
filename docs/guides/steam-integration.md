# Steam Integration

Proton-NV is packaged as a Steam Play compatibility tool. Once built and
installed it appears in Steam's compatibility-tool dropdown like Proton-GE.

## Install Locations

| Method | Location |
|--------|----------|
| `make install` | `~/.local/share/Steam/compatibilitytools.d/` |
| `PKGBUILD` (`makepkg -si`) | `/usr/share/steam/compatibilitytools.d/` |
| Pre-built release | extract into either of the above |

After installing, fully restart Steam so it rescans compatibility tools.

## Selecting Proton-NV

### Per game

1. Right-click the game → **Properties**.
2. **Compatibility** → **Force the use of a specific Steam Play compatibility
   tool**.
3. Select **Proton-NV** from the dropdown.

### Globally

**Steam → Settings → Compatibility → Run other titles with**, then choose
**Proton-NV**. Per-game selections override the global setting.

## Per-Game Launch Options

Launch options take precedence over `proton-nv.conf` and the user config. Append
`%command%`:

```
DXVK_HUD=fps,frametimes PROTON_ENABLE_REFLEX=1 %command%
```

To work around a regression on a single title, override the relevant variable —
for example dropping `descriptor_heap`:

```
VKD3D_CONFIG=force_static_cbv %command%
```

See [Configuration](../getting-started/configuration.md) and
[Environment Variables](../reference/environment-variables.md) for the full set.

## toolmanifest / compatibilitytool.vdf

The `dist` step generates the Steam metadata Proton-NV needs:

- `toolmanifest.vdf` — points Steam at the `proton` entrypoint and requires the
  Steam Linux Runtime tool app.
- `compatibilitytool.vdf` — registers the display name and install path.
- `version` — records the build version and target driver/GPU.

These are created automatically; you don't edit them by hand.

## Working Alongside nvproton

Proton-NV provides the runtime; **nvproton** manages per-game profiles, Reflex,
shader pre-warming, and launch options. They are complementary — Proton-NV can
be the compatibility tool that nvproton launches games with.

# Benchmarking

The `benchmark/` directory contains tools for measuring DX12 performance,
particularly for comparing before/after `VK_EXT_descriptor_heap`.

## Requirements

- MangoHud (`sudo pacman -S mangohud`)
- `jq` (optional, for JSON parsing)
- Steam with the test games installed

## Scripts

### proton-nv-bench.sh

Captures frame times via MangoHud for a single run.

```bash
./benchmark/proton-nv-bench.sh <steam_appid> [test_name] [duration_seconds]

# Examples
./benchmark/proton-nv-bench.sh 1091500 baseline 120     # Cyberpunk 2077 baseline
./benchmark/proton-nv-bench.sh 1091500 with_patch 120   # after a change

# Compare two runs
./benchmark/proton-nv-bench.sh compare \
  results/Cyberpunk2077/baseline_* results/Cyberpunk2077/with_patch_*
```

### test-descriptor-heap.sh

Automated A/B test: runs the same game twice with different `VKD3D_CONFIG`
values to isolate the descriptor-heap effect.

```bash
./benchmark/test-descriptor-heap.sh 1091500 120   # Cyberpunk 2077, 2 min each
```

Requires a driver exposing `VK_EXT_descriptor_heap` (595 / 600 / 610). See
[Driver Support](driver-support.md).

## Good DX12 Test Candidates

| App ID | Game | Notes |
|--------|------|-------|
| 1091500 | Cyberpunk 2077 | Heavy DX12 stress test |
| 1817190 | STALKER 2 | Known historical 590.x issues |
| 1240440 | Halo Infinite | NVIDIA perf improvements in vkd3d-proton 3.0 |
| 556760 | Death Stranding | DX12 mode |
| 1172620 | Sea of Thieves | DX12 only |
| 2050650 | Starfield | Heavy DX12 |
| 2514160 | Helldivers 2 | Popular DX12 title |

## Output Layout

Results are written under `results/<GameName>/<test_name>_<timestamp>/`:

```
results/
└── Cyberpunk2077/
    ├── baseline_<timestamp>/
    │   ├── system_info.txt   # driver, GPU, config
    │   ├── frametime.csv      # raw MangoHud data
    │   └── summary.txt        # FPS stats
    └── descriptor_heap_<timestamp>/
        └── ...
```

## Method

- Use a consistent benchmark scene (same in-game area each run).
- Close background applications.
- Let the GPU reach steady-state temperature before measuring.
- Run multiple passes and average; use at least 120 seconds per run.

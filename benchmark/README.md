# Proton-NV Benchmark Tools

Tools for measuring DX12 performance, especially for comparing before/after VK_EXT_descriptor_heap.

## Requirements

- MangoHud (`sudo pacman -S mangohud`)
- jq (optional, for JSON parsing)
- Steam with games installed

## Scripts

### proton-nv-bench.sh

Main benchmark tool. Captures frame times via MangoHud.

```bash
# Basic usage
./proton-nv-bench.sh <steam_appid> [test_name] [duration_seconds]

# Examples
./proton-nv-bench.sh 1091500 baseline 120      # Cyberpunk 2077 baseline
./proton-nv-bench.sh 1091500 with_patch 120    # After changes

# Compare two runs
./proton-nv-bench.sh compare results/Cyberpunk2077/baseline_* results/Cyberpunk2077/with_patch_*
```

### test-descriptor-heap.sh

Automated A/B test for VK_EXT_descriptor_heap. Runs the same game twice with different configs.

```bash
./test-descriptor-heap.sh 1091500 120   # Cyberpunk 2077, 2 min each
```

**Note:** Requires driver with VK_EXT_descriptor_heap (NVIDIA 595+ or Vulkan beta 580.94.16+)

## Known DX12 Games (Good Test Candidates)

| App ID | Game | Notes |
|--------|------|-------|
| 1091500 | Cyberpunk 2077 | Heavy DX12, good stress test |
| 1817190 | STALKER 2 | Known 590.x issues |
| 1240440 | Halo Infinite | NVIDIA perf improvements in 3.0 |
| 556760 | Death Stranding | DX12 mode |
| 1172620 | Sea of Thieves | DX12 only |
| 2050650 | Starfield | Heavy DX12 |
| 2514160 | Helldivers 2 | Popular DX12 title |

## Output

Results are saved to `results/<GameName>/<test_name>_<timestamp>/`:

```
results/
└── Cyberpunk2077/
    ├── baseline_20260127_143022/
    │   ├── system_info.txt    # Driver, GPU, config
    │   ├── frametime.csv      # Raw MangoHud data
    │   └── summary.txt        # FPS stats
    └── descriptor_heap_20260127_144522/
        └── ...
```

## Workflow: Testing descriptor_heap

### Before Driver Release (Current)

1. Run baseline benchmarks on games you care about:
   ```bash
   export VKD3D_CONFIG="force_static_cbv"
   ./proton-nv-bench.sh 1091500 baseline_590 120
   ```

2. Save results for later comparison.

### After 595+ Driver Release

1. Update driver
2. Build Proton-NV dev branch:
   ```bash
   make dev
   ```
3. Run A/B test:
   ```bash
   ./test-descriptor-heap.sh 1091500 120
   ```
4. Compare results:
   ```bash
   ./proton-nv-bench.sh compare results/*/baseline_* results/*/descriptor_heap_*
   ```

## Tips

- Use a consistent benchmark scene (same area in game)
- Close background applications
- Let GPU reach steady-state temperature before testing
- Run multiple tests and average results
- 120 seconds minimum for reliable data

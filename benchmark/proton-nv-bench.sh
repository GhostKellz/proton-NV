#!/bin/bash
#
# Proton-NV Benchmark Tool
# Measures DX12 performance for before/after comparison
#
# Requirements:
#   - MangoHud (mangohud package)
#   - jq (for JSON parsing)
#   - A game installed via Steam
#
# Usage:
#   ./proton-nv-bench.sh <steam_appid> [test_name] [duration_seconds]
#
# Example:
#   ./proton-nv-bench.sh 1091500 "baseline" 120    # Cyberpunk 2077
#   ./proton-nv-bench.sh 1091500 "descriptor_heap" 120
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="${SCRIPT_DIR}/results"
MANGOHUD_LOG_DIR="${HOME}/.local/share/MangoHud"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
DURATION=120
TEST_NAME="benchmark"

usage() {
    echo "Proton-NV Benchmark Tool"
    echo ""
    echo "Usage: $0 <steam_appid> [test_name] [duration_seconds]"
    echo ""
    echo "Arguments:"
    echo "  steam_appid      Steam App ID of the game to benchmark"
    echo "  test_name        Name for this test run (default: benchmark)"
    echo "  duration         Benchmark duration in seconds (default: 120)"
    echo ""
    echo "Examples:"
    echo "  $0 1091500 baseline 120        # Cyberpunk 2077 baseline"
    echo "  $0 1091500 descriptor_heap 120 # After enabling descriptor_heap"
    echo ""
    echo "Known DX12 Game IDs:"
    echo "  1091500  - Cyberpunk 2077"
    echo "  1817190  - STALKER 2"
    echo "  1240440  - Halo Infinite"
    echo "  556760   - Death Stranding"
    echo "  1172620  - Sea of Thieves"
    echo "  2050650  - Starfield"
    echo "  2514160  - Helldivers 2"
    exit 1
}

check_deps() {
    local missing=0

    if ! command -v mangohud &> /dev/null; then
        echo -e "${RED}ERROR: MangoHud not found${NC}"
        echo "Install: sudo pacman -S mangohud (Arch) or sudo apt install mangohud (Debian)"
        missing=1
    fi

    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}WARNING: jq not found - JSON output disabled${NC}"
    fi

    if ! command -v steam &> /dev/null; then
        echo -e "${RED}ERROR: Steam not found${NC}"
        missing=1
    fi

    if [ $missing -eq 1 ]; then
        exit 1
    fi
}

setup_mangohud() {
    # Create MangoHud config for benchmarking
    local config_dir="${HOME}/.config/MangoHud"
    mkdir -p "$config_dir"

    cat > "${config_dir}/proton-nv-bench.conf" << 'EOF'
# Proton-NV Benchmark MangoHud Config
legacy_layout=false
fps
frametime
frame_timing
gpu_stats
gpu_temp
gpu_power
cpu_stats
cpu_temp
ram
vram
log_duration=0
autostart_log=0
log_interval=100
output_folder=/tmp/proton-nv-bench
permit_upload=0
EOF

    echo -e "${GREEN}MangoHud config created${NC}"
}

get_game_name() {
    local appid="$1"
    # Known games
    case "$appid" in
        1091500) echo "Cyberpunk2077" ;;
        1817190) echo "STALKER2" ;;
        1240440) echo "HaloInfinite" ;;
        556760)  echo "DeathStranding" ;;
        1172620) echo "SeaOfThieves" ;;
        2050650) echo "Starfield" ;;
        2514160) echo "Helldivers2" ;;
        *)       echo "Game${appid}" ;;
    esac
}

capture_system_info() {
    local output_file="$1"

    echo "# System Information" > "$output_file"
    echo "timestamp=$(date -Iseconds)" >> "$output_file"
    echo "hostname=$(hostname)" >> "$output_file"

    # NVIDIA driver
    if command -v nvidia-smi &> /dev/null; then
        echo "nvidia_driver=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -1)" >> "$output_file"
        echo "nvidia_gpu=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)" >> "$output_file"
        echo "nvidia_vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | head -1)" >> "$output_file"
    fi

    # Kernel
    echo "kernel=$(uname -r)" >> "$output_file"

    # Proton-NV config
    echo "VKD3D_CONFIG=${VKD3D_CONFIG:-not_set}" >> "$output_file"
    echo "DXVK_ASYNC=${DXVK_ASYNC:-not_set}" >> "$output_file"
    echo "PROTON_NV_DESCRIPTOR_HEAP=${PROTON_NV_DESCRIPTOR_HEAP:-not_set}" >> "$output_file"

    # Check for descriptor_heap extension
    if command -v vulkaninfo &> /dev/null; then
        if vulkaninfo 2>/dev/null | grep -q "VK_EXT_descriptor_heap"; then
            echo "vk_ext_descriptor_heap=available" >> "$output_file"
        else
            echo "vk_ext_descriptor_heap=not_available" >> "$output_file"
        fi
    fi
}

run_benchmark() {
    local appid="$1"
    local test_name="$2"
    local duration="$3"

    local game_name=$(get_game_name "$appid")
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local result_dir="${RESULTS_DIR}/${game_name}/${test_name}_${timestamp}"

    mkdir -p "$result_dir"

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Proton-NV Benchmark${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo -e "Game:     ${GREEN}${game_name}${NC} (${appid})"
    echo -e "Test:     ${GREEN}${test_name}${NC}"
    echo -e "Duration: ${GREEN}${duration}s${NC}"
    echo -e "Output:   ${GREEN}${result_dir}${NC}"
    echo ""

    # Capture system info
    capture_system_info "${result_dir}/system_info.txt"
    echo -e "${GREEN}System info captured${NC}"

    # Setup MangoHud logging
    local log_file="/tmp/proton-nv-bench/MangoHud_${appid}.csv"
    mkdir -p /tmp/proton-nv-bench
    rm -f "$log_file"

    echo -e "${YELLOW}Starting game in ${duration} seconds benchmark mode...${NC}"
    echo -e "${YELLOW}Press F12 to start/stop logging (if autostart doesn't work)${NC}"
    echo ""

    # Launch game with MangoHud
    MANGOHUD_CONFIGFILE="${HOME}/.config/MangoHud/proton-nv-bench.conf" \
    MANGOHUD_OUTPUT="/tmp/proton-nv-bench" \
    MANGOHUD=1 \
    steam -applaunch "$appid" &

    local steam_pid=$!

    echo -e "${BLUE}Game launched. Waiting for benchmark duration...${NC}"
    echo -e "${YELLOW}Play normally or run a consistent benchmark scene${NC}"
    echo ""

    # Wait for duration
    for ((i=duration; i>0; i--)); do
        printf "\r${BLUE}Time remaining: %3d seconds${NC}" "$i"
        sleep 1
    done
    echo ""

    echo -e "${YELLOW}Benchmark complete. Please close the game.${NC}"

    # Wait for log file
    sleep 5

    # Copy results
    if [ -f "$log_file" ]; then
        cp "$log_file" "${result_dir}/frametime.csv"
        echo -e "${GREEN}Frametime data captured${NC}"

        # Generate summary
        generate_summary "${result_dir}/frametime.csv" "${result_dir}/summary.txt"
    else
        echo -e "${RED}WARNING: No frametime data found${NC}"
        echo -e "${YELLOW}Make sure MangoHud logging was enabled (F12)${NC}"
    fi

    echo ""
    echo -e "${GREEN}Results saved to: ${result_dir}${NC}"
}

generate_summary() {
    local csv_file="$1"
    local output_file="$2"

    if [ ! -f "$csv_file" ]; then
        echo "No data" > "$output_file"
        return
    fi

    # Parse CSV and generate statistics
    # MangoHud CSV format: fps,frametime,cpu_load,gpu_load,...

    echo "# Benchmark Summary" > "$output_file"
    echo "generated=$(date -Iseconds)" >> "$output_file"
    echo "" >> "$output_file"

    # Use awk to calculate statistics
    awk -F',' '
    NR > 1 {
        fps[NR-1] = $1
        frametime[NR-1] = $2
        count++
        fps_sum += $1
        ft_sum += $2
        if ($1 > fps_max || fps_max == "") fps_max = $1
        if ($1 < fps_min || fps_min == "") fps_min = $1
        if ($2 > ft_max || ft_max == "") ft_max = $2
        if ($2 < ft_min || ft_min == "") ft_min = $2
    }
    END {
        if (count > 0) {
            fps_avg = fps_sum / count
            ft_avg = ft_sum / count

            # Calculate 1% and 0.1% lows
            n = asort(fps, sorted_fps)
            fps_1pct = sorted_fps[int(n * 0.01) + 1]
            fps_01pct = sorted_fps[int(n * 0.001) + 1]

            # Calculate 99th percentile frametime
            n = asort(frametime, sorted_ft)
            ft_99pct = sorted_ft[int(n * 0.99)]

            print "frames=" count
            print "fps_avg=" fps_avg
            print "fps_min=" fps_min
            print "fps_max=" fps_max
            print "fps_1pct_low=" fps_1pct
            print "fps_01pct_low=" fps_01pct
            print "frametime_avg_ms=" ft_avg
            print "frametime_min_ms=" ft_min
            print "frametime_max_ms=" ft_max
            print "frametime_99pct_ms=" ft_99pct
        }
    }
    ' "$csv_file" >> "$output_file"

    echo -e "${GREEN}Summary generated${NC}"
    cat "$output_file"
}

compare_results() {
    local result1="$1"
    local result2="$2"

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Benchmark Comparison${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    if [ ! -f "$result1/summary.txt" ] || [ ! -f "$result2/summary.txt" ]; then
        echo -e "${RED}ERROR: Summary files not found${NC}"
        return 1
    fi

    echo -e "Baseline: ${GREEN}$(basename $(dirname $result1))${NC}"
    echo -e "Test:     ${GREEN}$(basename $(dirname $result2))${NC}"
    echo ""

    # Extract values and compare
    local fps1=$(grep "fps_avg" "$result1/summary.txt" | cut -d= -f2)
    local fps2=$(grep "fps_avg" "$result2/summary.txt" | cut -d= -f2)

    local low1=$(grep "fps_1pct_low" "$result1/summary.txt" | cut -d= -f2)
    local low2=$(grep "fps_1pct_low" "$result2/summary.txt" | cut -d= -f2)

    echo "Metric              Baseline    Test        Change"
    echo "------------------------------------------------------"
    printf "Average FPS         %-10.1f  %-10.1f  %+.1f%%\n" "$fps1" "$fps2" "$(echo "scale=1; ($fps2 - $fps1) / $fps1 * 100" | bc)"
    printf "1%% Low FPS          %-10.1f  %-10.1f  %+.1f%%\n" "$low1" "$low2" "$(echo "scale=1; ($low2 - $low1) / $low1 * 100" | bc)"
}

# Main
if [ $# -lt 1 ]; then
    usage
fi

case "$1" in
    -h|--help)
        usage
        ;;
    compare)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 compare <result_dir1> <result_dir2>"
            exit 1
        fi
        compare_results "$2" "$3"
        ;;
    *)
        APPID="$1"
        TEST_NAME="${2:-benchmark}"
        DURATION="${3:-120}"

        check_deps
        setup_mangohud

        mkdir -p "$RESULTS_DIR"

        run_benchmark "$APPID" "$TEST_NAME" "$DURATION"
        ;;
esac

#!/bin/bash
#
# Proton-NV: VK_EXT_descriptor_heap A/B Test
#
# Runs the same game twice:
#   1. Baseline (force_static_cbv only)
#   2. With descriptor_heap enabled
#
# Compares results automatically.
#
# Usage:
#   ./test-descriptor-heap.sh <steam_appid> [duration]
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -lt 1 ]; then
    echo "Usage: $0 <steam_appid> [duration_seconds]"
    echo ""
    echo "This script runs an A/B test comparing:"
    echo "  A) VKD3D_CONFIG=force_static_cbv (baseline)"
    echo "  B) VKD3D_CONFIG=force_static_cbv,descriptor_heap"
    echo ""
    echo "Example: $0 1091500 120  # Cyberpunk 2077, 2 minutes each"
    exit 1
fi

APPID="$1"
DURATION="${2:-120}"

# Check if descriptor_heap is available
echo -e "${BLUE}Checking for VK_EXT_descriptor_heap...${NC}"

if command -v vulkaninfo &> /dev/null; then
    if vulkaninfo 2>/dev/null | grep -q "VK_EXT_descriptor_heap"; then
        echo -e "${GREEN}VK_EXT_descriptor_heap is AVAILABLE${NC}"
    else
        echo -e "${RED}VK_EXT_descriptor_heap is NOT AVAILABLE${NC}"
        echo ""
        echo "This test requires a driver with VK_EXT_descriptor_heap support:"
        echo "  - NVIDIA Vulkan beta 580.94.16+"
        echo "  - NVIDIA 595+ (when released)"
        echo ""
        echo "You can still run the baseline test manually:"
        echo "  ./proton-nv-bench.sh $APPID baseline $DURATION"
        exit 1
    fi
else
    echo -e "${YELLOW}WARNING: vulkaninfo not found, cannot verify extension${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}VK_EXT_descriptor_heap A/B Test${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Game:     ${GREEN}$APPID${NC}"
echo -e "Duration: ${GREEN}${DURATION}s per run${NC}"
echo -e "Total:    ${GREEN}$((DURATION * 2))s + setup time${NC}"
echo ""

# Run A: Baseline
echo -e "${YELLOW}=== TEST A: Baseline (force_static_cbv) ===${NC}"
export VKD3D_CONFIG="force_static_cbv"
export PROTON_NV_DESCRIPTOR_HEAP=0
"${SCRIPT_DIR}/proton-nv-bench.sh" "$APPID" "baseline_static_cbv" "$DURATION"

echo ""
echo -e "${YELLOW}Waiting 30 seconds before next test...${NC}"
sleep 30

# Run B: With descriptor_heap
echo -e "${YELLOW}=== TEST B: descriptor_heap enabled ===${NC}"
export VKD3D_CONFIG="force_static_cbv,descriptor_heap"
export PROTON_NV_DESCRIPTOR_HEAP=1
"${SCRIPT_DIR}/proton-nv-bench.sh" "$APPID" "descriptor_heap" "$DURATION"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}A/B Test Complete${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Results saved in: ${SCRIPT_DIR}/results/"
echo ""
echo "To compare results, find the two result directories and run:"
echo "  ./proton-nv-bench.sh compare <baseline_dir> <descriptor_heap_dir>"

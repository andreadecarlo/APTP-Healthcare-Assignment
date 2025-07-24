#!/bin/bash

# Script to test multiple Fast Downward configurations
# Usage: ./test_configurations.sh <problem_file>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <problem_file>"
    echo "Example: $0 pb.pddl"
    exit 1
fi

PROBLEM_FILE="$1"
DOMAIN="domain.pddl"
OUTPUT_FILE="configuration_comparison.csv"

# Check if files exist
if [ ! -f "$PROBLEM_FILE" ]; then
    echo "Error: Problem file '$PROBLEM_FILE' not found."
    exit 1
fi

if [ ! -f "$DOMAIN" ]; then
    echo "Error: Domain file '$DOMAIN' not found."
    exit 1
fi

# Add header if CSV file does not exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "configuration,problem,plan_length,expanded,evaluated,generated,search_time,memory_mb,exit_code" > "$OUTPUT_FILE"
    echo "Created new CSV file: $OUTPUT_FILE"
fi

problem_name=$(basename "$PROBLEM_FILE" .pddl)

# Define configurations to test (memory-efficient only)
declare -A configurations=(
    ["lama-first"]="--alias lama-first"
    ["seq-opt-lmcut"]="--alias seq-opt-lmcut"
    ["seq-sat-lama-2011"]="--alias seq-sat-lama-2011"
    ["astar-lmcut"]="astar(lmcut())"
    ["astar-ipdb"]="astar(ipdb())"
    ["astar-blind"]="astar(blind())"
    ["astar-ff"]="astar(ff())"
    ["astar-hmax"]="astar(hmax())"
    ["eager-greedy-ff"]="eager_greedy([ff()])"
)

echo "Testing configurations on problem: $problem_name"
echo "Results will be saved to: $OUTPUT_FILE"
echo "========================================"

# Test each configuration
for config_name in "${!configurations[@]}"; do
    config_cmd="${configurations[$config_name]}"
    
    echo ""
    echo "Testing configuration: $config_name"
    
    # Create temporary file for output
    TMP_OUT=$(mktemp)
    
    # Build command based on configuration type
    if [[ $config_cmd == --alias* ]]; then
        # Alias-based configuration
        full_command="downward $config_cmd $DOMAIN $PROBLEM_FILE"
    else
        # Search-based configuration
        full_command="downward $DOMAIN $PROBLEM_FILE --search \"$config_cmd\""
    fi
    
    echo "Command: $full_command"
    echo "----------------------------------------"
    
    # Set timeout (5 minutes = 300 seconds)
    timeout 300s bash -c "$full_command" > "$TMP_OUT" 2>&1
    exit_code=$?
    
    if [ $exit_code -eq 124 ]; then
        echo "TIMEOUT: Configuration took longer than 5 minutes"
        echo "$config_name,$problem_name,TIMEOUT,TIMEOUT,TIMEOUT,TIMEOUT,TIMEOUT,TIMEOUT,124" >> "$OUTPUT_FILE"
        rm "$TMP_OUT"
        continue
    elif [ $exit_code -eq 0 ]; then
        echo "SUCCESS: Planning completed"
        
        # Extract metrics with improved parsing
        plan_length=$(grep "Plan length:" "$TMP_OUT" | sed -E 's/.*Plan length: ([0-9]+).*/\1/' | head -1)
        expanded=$(grep "Expanded " "$TMP_OUT" | sed -E 's/.*Expanded ([0-9]+).*/\1/' | head -1)
        evaluated=$(grep "Evaluated " "$TMP_OUT" | sed -E 's/.*Evaluated ([0-9]+).*/\1/' | head -1)
        generated=$(grep "Generated " "$TMP_OUT" | grep -oE "Generated [0-9]+" | sed -E 's/Generated ([0-9]+)/\1/' | tail -1)
        search_time=$(grep "Search time:" "$TMP_OUT" | sed -E 's/.*Search time: ([0-9.]+)s.*/\1/' | head -1)
        
        # Extract memory in KB and convert to MB
        memory_kb=$(grep "Peak memory:" "$TMP_OUT" | sed -E 's/.*Peak memory: ([0-9]+) KB.*/\1/' | head -1)
        if [[ $memory_kb =~ ^[0-9]+$ ]]; then
            memory_mb=$(echo "scale=2; $memory_kb / 1024" | bc -l 2>/dev/null || echo "N/A")
        else
            memory_mb="N/A"
        fi
        
        # Handle missing values
        plan_length=${plan_length:-"N/A"}
        expanded=${expanded:-"N/A"}
        evaluated=${evaluated:-"N/A"}
        generated=${generated:-"N/A"}
        search_time=${search_time:-"N/A"}
        
        echo "  Plan length: $plan_length"
        echo "  Expanded nodes: $expanded"
        echo "  Evaluated nodes: $evaluated"
        echo "  Generated nodes: $generated"
        echo "  Search time: ${search_time}s"
        echo "  Peak memory: ${memory_mb} MB"
        
        # Remove existing entry for this configuration if it exists
        if [ -f "$OUTPUT_FILE" ]; then
            grep -v "^$config_name,$problem_name," "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" || true
            mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
        fi
        
        # Write to CSV
        echo "$config_name,$problem_name,$plan_length,$expanded,$evaluated,$generated,$search_time,$memory_mb,$exit_code" >> "$OUTPUT_FILE"
        
    else
        echo "FAILED: Planning failed with exit code $exit_code"
        
        # Check for specific failure reasons
        if grep -q "unsolvable" "$TMP_OUT"; then
            failure_reason="UNSOLVABLE"
        elif grep -q "out of memory\|memory limit" "$TMP_OUT"; then
            failure_reason="OUT_OF_MEMORY"
        else
            failure_reason="FAILED"
        fi
        
        echo "$config_name,$problem_name,$failure_reason,$failure_reason,$failure_reason,$failure_reason,$failure_reason,$failure_reason,$exit_code" >> "$OUTPUT_FILE"
    fi
    
    # Clean up
    rm "$TMP_OUT"
done

echo ""
echo "========================================"
echo "Configuration testing completed!"
echo "Results saved to: $OUTPUT_FILE"
echo ""
echo "Summary:"
echo "--------"

# Show a quick summary
echo "Configuration performance summary:"
awk -F',' 'NR>1 {
    if ($3 != "TIMEOUT" && $3 != "FAILED" && $3 != "UNSOLVABLE" && $3 != "OUT_OF_MEMORY") {
        printf "%-25s: Plan: %-4s Time: %-8ss Memory: %-6s MB Expanded: %s\n", $1, $3, $7, $8, $4
    } else {
        printf "%-25s: %s\n", $1, $3
    }
}' "$OUTPUT_FILE"

echo ""
echo "For detailed analysis, check the CSV file: $OUTPUT_FILE" 
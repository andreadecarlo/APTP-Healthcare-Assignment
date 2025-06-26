#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <domain_file> <problem_file>"
    echo "Example: $0 domain.pddl scaled_problems/all/2box_3patient_4loc.pddl"
    exit 1
fi

DOMAIN="$1"
PROBLEM_FILE="$2"
OUTPUT_FILE="ff_results.csv"

# Check if problem file exists
if [ ! -f "$PROBLEM_FILE" ]; then
    echo "Error: Problem file '$PROBLEM_FILE' not found."
    exit 1
fi

# Check if domain file exists
if [ ! -f "$DOMAIN" ]; then
    echo "Error: Domain file '$DOMAIN' not found in current directory."
    exit 1
fi

# Add header if CSV file does not exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "problem,boxes,patients,locations,carrier_capacity,plan_length,search_depth,num_states,time,num_facts,num_actions" > "$OUTPUT_FILE"
    echo "Created new CSV file: $OUTPUT_FILE"
fi

# Extract problem name
name=$(basename "$PROBLEM_FILE" .pddl)

# Function to count objects of a specific type in PDDL file
count_objects() {
    local problem_file="$1"
    local object_type="$2"
    
    # Extract the :objects section and count objects of the specified type
    # This handles multiple objects on the same line like "b1 b2 b3 - box"
    local count=$(awk '
    BEGIN { in_objects = 0; count = 0 }
    /^[[:space:]]*\(:objects[[:space:]]*$/ { in_objects = 1; next }
    /^[[:space:]]*\)/ { in_objects = 0; next }
    in_objects && /[[:space:]]*-[[:space:]]*'"$object_type"'[[:space:]]*$/ && !/robot-'"$object_type"'/ {
        # Count words before the type declaration
        line = $0
        gsub(/[[:space:]]*-[[:space:]]*'"$object_type"'[[:space:]]*$/, "", line)  # Remove type part
        gsub(/^[[:space:]]+/, "", line)  # Remove leading spaces
        gsub(/[[:space:]]+/, " ", line)  # Normalize spaces
        if (line != "") {
            # Count words (object names)
            split(line, words, " ")
            count += length(words)
        }
    }
    END { print count }' "$problem_file")
    echo "$count"
}

echo "Running planner on problem: $name"
echo "Problem file: $PROBLEM_FILE"
echo "Domain file: $DOMAIN"
echo "Results will be saved to: $OUTPUT_FILE"
echo "----------------------------------------"

# Extract object counts from PDDL file
boxes=$(count_objects "$PROBLEM_FILE" "box")
patients=$(count_objects "$PROBLEM_FILE" "patient")
locations=$(count_objects "$PROBLEM_FILE" "location")
carrier_capacity=$(grep "capacity " "$PROBLEM_FILE" | sed -E 's/.*capacity_([0-9]+).*/\1/')

echo "Problem parameters (extracted from PDDL):"
echo "  Boxes: $boxes"
echo "  Patients: $patients"
echo "  Locations: $locations"
echo "  carrier_capacity: $carrier_capacity"
echo ""

# Run planner and capture output
TMP_OUT=$(mktemp)
ff "$DOMAIN" "$PROBLEM_FILE" > "$TMP_OUT" 2>&1

plan_length=$(grep -A100 "found legal plan" "$TMP_OUT" | grep -E "^[[:space:]]*[0-9]+:" | wc -l)
search_depth=$(grep "max depth" "$TMP_OUT" | awk '{print $NF}')
num_states=$(grep "evaluating" "$TMP_OUT" | awk '{print $5}')
total_time=$(grep "total time" "$TMP_OUT" | awk '{print $1}')
num_facts=$(grep "final representation" "$TMP_OUT" | awk '{print $(NF-2)}')
num_actions=$(grep "reachability analysis" "$TMP_OUT" | awk '{print $(NF-1)}')


echo "$PROBLEM_FILE,$boxes,$patients,$locations,$carrier_capacity,$plan_length,$search_depth,$num_states,$total_time,$num_facts,$num_actions" >> "$OUTPUT_FILE"

rm "$TMP_OUT"

echo "Plan length: $plan_length"
echo "Search depth: $search_depth"
echo "Number of states: $num_states"
echo "Total time: $total_time"
echo "Number of facts: $num_facts"
echo "Number of actions: $num_actions"

echo "Results saved to: $OUTPUT_FILE"
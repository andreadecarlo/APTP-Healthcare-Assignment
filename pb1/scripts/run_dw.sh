#!/bin/bash

# Script to run downward planner on a single problem file
# Usage: ./run_single_problem.sh <problem_file>

# Check if problem file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <problem_file>"
    echo "Example: $0 scaled_problems/all/2box_3patient_4loc.pddl"
    exit 1
fi

PROBLEM_FILE="$1"
DOMAIN="domain.pddl"
OUTPUT_FILE="single_problem_results.csv"

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
    echo "problem,boxes,patients,locations,plan_length,expanded,evaluated,generated,search_time" > "$OUTPUT_FILE"
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

echo "Problem parameters (extracted from PDDL):"
echo "  Boxes: $boxes"
echo "  Patients: $patients"
echo "  Locations: $locations"
echo ""

# Run planner and capture output
TMP_OUT=$(mktemp)
downward --alias lama-first "$DOMAIN" "$PROBLEM_FILE" > "$TMP_OUT" 2>&1

# Check if planning was successful
if [ $? -eq 0 ]; then
    echo "Planning completed successfully!"
    echo ""
    
    # Extract metrics
    plan_length=$(grep "Plan length:" "$TMP_OUT" | sed -E 's/.*Plan length: ([0-9]+).*/\1/')
    expanded=$(grep "Expanded " "$TMP_OUT" | sed -E 's/.*Expanded ([0-9]+).*/\1/')
    evaluated=$(grep "Evaluated " "$TMP_OUT" | sed -E 's/.*Evaluated ([0-9]+).*/\1/')
    generated=$(grep "Generated " "$TMP_OUT" | tail -1 | sed -E 's/.*Generated ([0-9]+).*/\1/')
    search_time=$(grep "Search time:" "$TMP_OUT" | sed -E 's/.*Search time: ([0-9.]+)s.*/\1/')
    
    echo "Results:"
    echo "  Plan length: $plan_length"
    echo "  Expanded nodes: $expanded"
    echo "  Evaluated nodes: $evaluated"
    echo "  Generated nodes: $generated"
    echo "  Search time: ${search_time}s"
    
    # Write to CSV
    echo "$name,$boxes,$patients,$locations,$plan_length,$expanded,$evaluated,$generated,$search_time" >> "$OUTPUT_FILE"
    echo ""
    echo "Results saved to $OUTPUT_FILE"
    
else
    echo "Planning failed!"
    echo "Full output:"
    cat "$TMP_OUT"
fi

# Clean up
rm "$TMP_OUT" 
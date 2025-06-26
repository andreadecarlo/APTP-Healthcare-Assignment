#!/bin/bash

# planutils activate  # activate planutils environment

DOMAIN="../domain.pddl"
OUTPUT_FILE="scaling_results.csv"

# Add header if file does not exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "problem,boxes,patients,locations,carrier_capacity,plan_length,expanded,evaluated,generated,search_time" > "$OUTPUT_FILE"
fi

for problem in scaled_problems/box/*.pddl; do
    name=$(basename "$problem" .pddl)

    # Count objects from the problem file
    boxes=$(echo "$name" | grep -oP '\d+(?=box)')
    patients=$(echo "$name" | grep -oP '\d+(?=patient)')
    locations=$(echo "$name" | grep -oP '\d+(?=loc)')
    carrier_capacity=$(echo "$name" | grep -oP '\d+(?=carr)')

    echo "Running $name"
    echo "running $problem"

    # Run planner and capture output
    TMP_OUT=$(mktemp)
    downward --alias lama-first "$DOMAIN" "$problem" > "$TMP_OUT" 2>&1

    echo "Runned planner"

    # Extract metrics
    plan_length=$(grep "Plan length:" "$TMP_OUT" | sed -E 's/.*Plan length: ([0-9]+).*/\1/')
    expanded=$(grep "Expanded " "$TMP_OUT" | sed -E 's/.*Expanded ([0-9]+).*/\1/')
    evaluated=$(grep "Evaluated " "$TMP_OUT" | sed -E 's/.*Evaluated ([0-9]+).*/\1/')
    generated=$(grep "Generated " "$TMP_OUT" | sed -E 's/.*Generated ([0-9]+).*/\1/')
    search_time=$(grep "Search time:" "$TMP_OUT" | sed -E 's/.*Search time: ([0-9.]+)s.*/\1/')


    echo "Plan length: $plan_length"
    echo "Expanded: $expanded"
    echo "Evaluated: $evaluated"
    echo "Generated: $generated"
    echo "Search time: $search_time"

    # Write to CSV
    echo "$name,$boxes,$patients,$locations,$carrier_capacity,$plan_length,$expanded,$evaluated,$generated,$search_time" >> "$OUTPUT_FILE"

    rm "$TMP_OUT"
done

echo "Saved results in $OUTPUT_FILE"

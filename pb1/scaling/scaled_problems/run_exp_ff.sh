#!/bin/bash

DOMAIN="../domain.pddl"
OUTPUT_FILE="scaling_results.csv"

# Add header if file does not exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "problem,plan_length,search_depth,num_states,time,num_facts,num_actions" > "$OUTPUT_FILE"
fi

for problem in scaled_problems/all/*.pddl; do
    name=$(basename "$problem" .pddl)

    # Extract numbers from filename
    boxes=$(echo "$name" | grep -oP '\d+(?=box)')
    patients=$(echo "$name" | grep -oP '\d+(?=patient)')
    locations=$(echo "$name" | grep -oP '\d+(?=loc)')

    echo "Running $name"

    TMP_OUT=$(mktemp)
    echo "$DOMAIN"
    echo "$problem"

    ff "$DOMAIN" "$problem" > "$TMP_OUT" 2>&1

    plan_length=$(grep -A100 "found legal plan" "$TMP_OUT" | grep -E "^[[:space:]]*[0-9]+:" | wc -l)
    search_depth=$(grep "max depth" "$TMP_OUT" | awk '{print $NF}')
    num_states=$(grep "evaluating" "$TMP_OUT" | awk '{print $5}')
    total_time=$(grep "total time" "$TMP_OUT" | awk '{print $1}')
    num_facts=$(grep "final representation" "$TMP_OUT" | awk '{print $(NF-2)}')
    num_actions=$(grep "reachability analysis" "$TMP_OUT" | awk '{print $(NF-1)}')

    echo "$name,$plan_length,$search_depth,$num_states,$total_time,$num_facts,$num_actions" >> "$OUTPUT_FILE"

    rm "$TMP_OUT"
done

echo "Saved results in $OUTPUT_FILE"

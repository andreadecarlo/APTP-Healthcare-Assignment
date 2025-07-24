# Fast Downward Configuration Testing Guide

## Quick Usage

### Test all configurations on a problem:
```bash
./test_configurations.sh pb.pddl
```

### Test individual configurations:
```bash
# Using aliases (recommended for beginners)
downward --alias lama-first domain.pddl pb.pddl
downward --alias seq-opt-lmcut domain.pddl pb.pddl

# Using custom search configurations (--search flag comes AFTER domain and problem)
downward domain.pddl pb.pddl --search "astar(lmcut())"
downward domain.pddl pb.pddl --search "lazy_greedy([ff(), hmax()])"
```

## Configuration Categories

### 1. **Optimal Planners** (Find shortest plans)
- `seq-opt-lmcut`: Uses A* with LM-cut heuristic (very efficient for optimal planning)
- `astar(lmcut())`: A* search with landmark-cut heuristic
- `astar(ipdb())`: A* with incremental PDB heuristic (good balance of optimality and performance)
- `astar(blind())`: A* with blind heuristic (baseline, uninformed search)
- `astar(hmax())`: A* with hmax heuristic (admissible but usually weaker than LM-cut)

**Use when**: You need the shortest possible plan and can wait longer

### 2. **Satisficing Planners** (Find good plans quickly)
- `lama-first`: Fast, usually finds good quality plans quickly
- `seq-sat-lama-2011`: LAMA 2011 configuration for satisficing planning
- `lazy_greedy([hff], preferred=[hff])`: Greedy search with FF heuristic and preferred operators
- `lazy_greedy([hcea], preferred=[hcea])`: Greedy search with context-enhanced additive heuristic
- `lazy_greedy([hff, hcea], preferred=[hff, hcea])`: Multi-heuristic with FF and CEA

**Use when**: You want a reasonable plan quickly, plan quality less critical

### 3. **Greedy Search Variants** (Fast heuristic-guided search)
- `eager_greedy([ff()])`: Eager greedy best-first search with FF heuristic

**Use when**: You want very fast solutions with decent quality

## Heuristic Functions Explained

| Heuristic | Type | Strength | Speed | Best For |
|-----------|------|----------|-------|----------|
| `lmcut()` | Admissible | Very Strong | Slow | Optimal planning |
| `ipdb()` | Admissible | Strong | Medium | Optimal planning with better performance |
| `blind()` | Admissible | Very Weak | Very Fast | Testing, baseline comparison |
| `ff()` | Inadmissible | Strong | Fast | Satisficing planning |
| `cea()` | Inadmissible | Strong | Medium | Context-enhanced planning |
| `hmax()` | Admissible | Weak | Very Fast | Quick bounds |

## Search Algorithms

### A* (`astar`)
- **Optimal**: Yes (with admissible heuristic)
- **Memory**: High
- **Use**: When you need optimal solutions

### Greedy Best-First (`lazy_greedy`, `eager_greedy`)
- **Optimal**: No
- **Memory**: Medium
- **Use**: When you want fast solutions

### Weighted A* (`eager_wastar`)
- **Optimal**: Bounded (within weight factor)
- **Memory**: High
- **Use**: Trade-off between quality and speed

## Performance Analysis

After running `./test_configurations.sh`, analyze results by:

1. **Plan Quality**: Lower plan length = better
2. **Search Efficiency**: 
   - Lower expanded/evaluated nodes = more efficient
   - Lower search time = faster
3. **Memory Usage**: Lower peak memory = less resource intensive

## Common Configuration Patterns

### For Small Problems (< 50 actions):
```bash
downward --alias seq-opt-lmcut domain.pddl problem.pddl  # Optimal
```

### For Medium Problems (50-500 actions):
```bash
downward --alias lama-first domain.pddl problem.pddl     # Good balance
downward --alias seq-sat-lama-2011 domain.pddl problem.pddl  # LAMA 2011 satisficing
downward domain.pddl problem.pddl --search "astar(ipdb())"  # Optimal with better performance
```

### For Large Problems (> 500 actions):
```bash
downward domain.pddl problem.pddl --search "let(hff, ff(), lazy_greedy([hff], preferred=[hff]))"  # Fast FF-based
downward domain.pddl problem.pddl --search "let(hff, ff(), let(hcea, cea(), lazy_greedy([hff, hcea], preferred=[hff, hcea])))"  # Multi-heuristic
```

## Troubleshooting

### Problem takes too long:
- Switch from optimal to satisficing planners
- Use lazy_greedy instead of astar
- Try ipdb() instead of lmcut() for optimal planning
- Use eager_greedy for very fast results

### Out of memory:
- Use eager search instead of lazy search
- Try simpler heuristics (ff instead of lmcut)
- Reduce problem size

### No solution found:
- Check if problem is actually solvable
- Try different heuristics (some may work better for your domain)
- Increase time/memory limits

## Advanced Configurations

### Multi-heuristic with preferences:
```bash
downward domain.pddl problem.pddl --search "let(hff, ff(), let(hcea, cea(), lazy_greedy([hff, hcea], preferred=[hff, hcea])))"
```

### Using variable bindings for cleaner syntax:
```bash
# FF heuristic with preferred operators
downward domain.pddl problem.pddl --search "let(hff, ff(), lazy_greedy([hff], preferred=[hff]))"

# CEA heuristic with preferred operators  
downward domain.pddl problem.pddl --search "let(hcea, cea(), lazy_greedy([hcea], preferred=[hcea]))"
```

### Portfolio approach (try multiple):
```bash
# Run several configurations and take the best result
./test_configurations.sh problem.pddl
```

### Custom timeouts:
```bash
timeout 60s downward domain.pddl problem.pddl --search "astar(lmcut())"
```

## Integration with Your Scaling Experiments

To test configurations across all your scaled problems:

```bash
# Modify your existing scaling script
for config in "lama-first" "seq-sat-lama-2011" "astar(lmcut())" "astar(ipdb())"; do
    for problem in scaled_problems/all/*.pddl; do
        echo "Testing $config on $problem"
        if [[ $config == *"alias"* ]]; then
            downward --alias $config domain.pddl $problem
        else
            downward domain.pddl $problem --search "$config"
        fi
    done
done
``` 
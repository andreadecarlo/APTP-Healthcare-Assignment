online planner: http://editor.planning.domains

run docker from cli:

    $> docker run -v.:/computer -it --privileged myplanutils  bash

    docker exec -it bb2b1815f6cfe86f830124e15fe84db267db604fec183cad7ee0e155db076fcb /bin/sh

CHECK: if myplanutils is slow, try build with --platform linux/arm64

TODO: reduce CLI prompt prefix

running:

    $> downward --alias lama-first domain.pddl pb1.pddl  
produces `sas_plan`

---

    downward domain.pddl problem.pddl--search "astar(lmcut())"

better than -alias lama-first

---

    tfd domain.pddl problem.pddl


Planners to test:
- FF                ff domain.pddl problem.pddl
- Fast Downward     downward domain.pddl problem.pddl -alias ... --search ... 
- LAMA              downward domain.pddl problem.pddl --alias lama-first
- Probe
- BFS(f)
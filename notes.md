online planner: http://editor.planning.domains

run docker from cli:

    $> docker run -v.:/computer -it --privileged myplanutils  bash

    docker exec -it bb2b1815f6cfe86f830124e15fe84db267db604fec183cad7ee0e155db076fcb /bin/sh

running:

    $> downward --alias lama-first domain.pddl pb1.pddl  

    downward domain.pddl problem.pddl--search "astar(lmcut())"

    tfd domain.pddl problem.pddl

pb4:
    planutils activate:
    
    optic -N domain.pddl problem.pddl
    Avoids optimizing initial found solution! 
    Run weighted A* with W = 1.000, not restarting with goal states

    optic -N -W1,1 domain.pddl problem.pddl  
    Run weighted A* with W = 1.000, not restarting with goal states

    optic -N -E -W1,1 domain.pddl problem.pddl 
    Run weighted A* with W = 1.000, not restarting with goal states 
    Skip EHC: go straight to best-first search

    tfd domain.pddl problem.pddl 
    No particular flags supported


Planners to test:
- FF                ff domain.pddl problem.pddl
- Fast Downward     downward domain.pddl problem.pddl -alias ... --search ... 
- LAMA              downward domain.pddl problem.pddl --alias lama-first
- Probe
- BFS(f)
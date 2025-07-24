# PB1

## commands:

docker build --rm  --tag myplauntils . --file Dockerfile
docker run -v .:/computer -it --privileged --rm myplanutils bash

TODO: check folder position when doing git clone

### inside the container:

cd /computer/pb1

planutils activate

downward --alias lama-first domain.pddl problem.pddl
downward domain.pddl problem.pddl --search "astar(lmcut())"
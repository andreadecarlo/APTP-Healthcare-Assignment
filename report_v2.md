<!-- approach is to keep as simple as possible keeping in mind complexity and readability in order to use more planners -->

we used STRIPS: if literal not in database assumed to be false

A domain file for predicates, and actions  
A problem file for objects, initial states, and goal descriptions

Type hierarchies for ...
Predefined "topmost super-type": object
to avoid multiple predicates for different types

Constants for central_warehouse and entrance

some redundant predicates can be necessary for some planners to help heuristics
states = 2 ^ (n^parameters) * predicates

GOAL is a list of true atoms
strips supports only positive conjunctive goals
the state of the node has to satisfy the goal formula
positive/negative can be buggy in some planners [CHECK WHICH]
we specify only the important and required goals, so that other facts follow implicitly

Operators (or actions)

[add FLYING predicate, takeoff(rob, A) -> Flying -> land(rob, b)]

expressivity requirements (see https://planning.wiki/ref/pddl/requirements) are ignored silently by most of the planners

Move action:
like drive for truck
there must be a path between current location and destination, so we need a new predicate "connected"
to avoid the use of not always supported "forall, implies", we add an additional operator "from" and constrain the variable "at" in the precondition
(alternative is to use exists (?from - location) (and (at ?t ?from) (path-between ?from ?dest)) without new parameter)

disjunctive precondition presumes additional branching for backward search

FastForward (FF) uses enforced hill climbing – approximately - that is not complete (if we commit to a part of the plan and then find no solution, FF restarts completely, using best-first-search)

**for temporal planning**
Partial Order Causal Link planning delays commitment to action ordering, place operators in known places in time
Allen's Interval Algebra

Planners to test:
A*
LAMA 2011


**for HTN**
In classical planning Objective is to achieve a goal
in HTN Objective is to perform a task
- Use "templates" to incrementally refine the task until primitive actions are reached!
- A primitive task corresponds directly to an action
- A method specifies one way to decompose a non-primitive task into sub-tasks.

Define a task ad use it as the initial task network

Avoid to repeat method for different conditions: make the choice in the subtask
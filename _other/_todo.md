# pb1
[x] create script that store command for a given problem as argument
[] DW si blocca con 3 patient and 3 boxes, check with different locations and less locations
    [] trova punto di blocco e prova diverse euristiche
    - punto di blocco? 4b4p_far2l
    - Quali euristiche?

[] generated | evaluated nodes x location
[] compare search time, we need plots for dw

# pb2
[x] scaling on carrier
[x] compare dw many boxes time of pb1 
LOCATIONS | BOXES | CARRIER
2 3 1 df
2 3 2 d
2 3 3 d
2 4 1 df
2 4 2 d
2 4 3 d
2 4 4 d
2 5 1 f
2 5 2 d
2 5 3 d
2 5 4 --
2 5 5 d

3 2 1 df
3 2 2 df
3 3 1 d-
3 3 2 d-
3 3 3 d-
3 4 1 d-
3 4 2 d-
3 4 3 d-
3 4 4 d-
3 5 1 --
3 5 2 d-
3 5 3 d-
3 5 4 d-
3 5 5 --

4 2 1 df
4 2 2 df
4 3 1 d-
4 3 2 d-
4 3 3 d-
4 4 1 d-
4 4 2 d-
4 4 3 d-
4 4 4 d-
4 5 1 d-
4 5 2 d-
4 5 3 d-
4 5 4 d-
4 5 5 --

pb3
[] scalability on old domain (1 capacity)

[] handle multi boxes       check this https://github.dev/lorenzialessandro/health-care-planning/tree/main/problem_3 (he handles it but max 3)
- prof doesn't care, 70% skippable
    [] take advantage of recursion
    [] can I use methods inside method?
    [] use all_delivered task with wants?????

pb4

pb5


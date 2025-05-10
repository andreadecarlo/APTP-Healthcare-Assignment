(define (problem problem2) (:domain healthcare)
(:objects 
    r1 - robot-box
    r2 - robot-patient
    
    b1 b2 b3 - box

    u1 u2 u3 - unit
    l1 l2 l3 - location

    p1 p2 - patient

    c1 - carrier

    capacity_0 - capacity_number
	capacity_1 - capacity_number
    capacity_2 - capacity_number
    capacity_3 - capacity_number
)

(:init
    (at b1 central_warehouse)
    (at b2 central_warehouse)
    (at b3 central_warehouse)

    (empty-box b1)
    (empty-box b2)
    (empty-box b3)

    (at scalpel central_warehouse)
    (at tongue_depressor central_warehouse)
    (at aspirin central_warehouse)
    (at bandage central_warehouse)
    (at thermometer central_warehouse)

    (at u1 l1)
    (at u2 l2)
    (at u3 l3)

    (at r1 central_warehouse)
    (at r2 entrance)

    ; (unloaded r1)

    (at p1 entrance)
    (at p2 entrance)
    
    (connected central_warehouse entrance)
    (connected entrance l1)
    (connected entrance l2)
    (connected entrance l3)
    (connected central_warehouse l1)
    (connected central_warehouse l2)
    (connected central_warehouse l3)
    (connected l1 l2)
    (connected l1 l3)
    (connected l2 l3)

    ; ---- carrier ----

    (at c1 central_warehouse)
    (rob-carrier r1 c1)
    ; (= (max_load_capacity c1) 2)
    ; (= (num_box_carried c1) 0)
    (capacity_predecessor capacity_0 capacity_1)
    (capacity_predecessor capacity_1 capacity_2)
    (capacity_predecessor capacity_2 capacity_3)
    (capacity c1 capacity_2)
)

(:goal (and
    ;todo: put the goal condition here
    (unit-has-content u1 scalpel)
    (unit-has-content u1 bandage)
    (unit-has-content u2 thermometer)

    ; (patient-at p1 l1)
    ; (patient-at p2 l2)

    (at-unit p1 u1)
    (at-unit p2 u2)
))

;un-comment the following line if metric is needed
(:metric minimize (total-cost))
)


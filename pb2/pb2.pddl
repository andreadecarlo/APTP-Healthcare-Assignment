(define (problem problem1) (:domain healthcare)
(:objects 
    r1 - robot-box
    r2 - robot-escort
    
    b1 b2 b3 - box

    u1 u2 u3 - unit
    l1 l2 l3 - location

    p1 p2 - patient

    c1 - carrier


)

(:init
    (box-at b1 central_warehouse)
    (box-at b2 central_warehouse)
    (box-at b3 central_warehouse)

    (empty-box b1)
    (empty-box b2)
    (empty-box b3)

    (content-at scalpel central_warehouse)
    (content-at tongue_depressor central_warehouse)
    (content-at aspirin central_warehouse)
    (content-at bandage central_warehouse)
    (content-at thermometer central_warehouse)

    (unit-at u1 l1)
    (unit-at u2 l2)
    (unit-at u3 l3)

    (robot-at r1 central_warehouse)
    (robot-at r2 entrance)

    ; (unloaded r1)

    (patient-at p1 entrance)
    (patient-at p2 entrance)
    
    (connected central_warehouse entrance)
    (connected entrance l1)
    (connected entrance l2)
    (connected entrance l3)
    (connected central_warehouse l1)
    (connected central_warehouse l2)
    (connected central_warehouse l3)

    ; ---- carrier ----

    (carrier-at c1 central_warehouse)
    (rob-carrier r1 c1)
    (= (max_load_capacity c1) 2)
    (= (num_box_carried c1) 0)
)

(:goal (and
    ;todo: put the goal condition here
    (unit-has-content u1 scalpel)
    (unit-has-content u1 bandage)
    (unit-has-content u2 thermometer)

    ; (patient-at p1 l1)
    ; (patient-at p2 l2)

    (patient-at-unit p1 u1)
    (patient-at-unit p2 u2)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)


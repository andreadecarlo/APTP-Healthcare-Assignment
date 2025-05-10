(define (problem problem1) (:domain healthcare)
(:objects 
    r1 - robot-box
    r2 - robot-patient
    
    b1 b2 b3 - box

    u1 u2 u3 - unit
    l1 l2 l3 u4 - location

    p1 p2 - patient
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
    (unit-at u4 l3)

    (robot-at r1 central_warehouse)
    (robot-at r2 entrance)

    (unloaded r1)

    (patient-at p1 entrance)
    (patient-at p2 entrance)
    
    (connected central_warehouse entrance)
    (connected entrance l1)
    (connected entrance l2)
    (connected entrance l3)
    (connected central_warehouse l1)
    (connected central_warehouse l2)
    (connected central_warehouse l3)
)

(:goal (and

    (unit-has-content u1 scalpel)
    (unit-has-content u1 bandage)
    (unit-has-content u2 thermometer)

    (patient-at-unit p1 u1)
    (patient-at-unit p2 u2)
))

)


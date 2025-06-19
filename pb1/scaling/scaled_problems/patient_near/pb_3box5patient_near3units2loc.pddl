(define (problem problem1) (:domain healthcare)
(:objects 
    r1 - robot-box
    r2 - robot-patient
    
    b1 b2 b3 - box

    u1 u2 u3 - unit
    l1 l2 - location

    p1 p2 p3 p4 p5 - patient
)

(:init
    (at b1 central_warehouse)
    (at b2 central_warehouse)
    (at b3 central_warehouse)

    (empty-box b1)
    (empty-box b2)
    (empty-box b3)

    (at tongue_depressor central_warehouse)
    (at scalpel central_warehouse)

    (at u1 l1)
    (at u2 l2)
    (at u3 l2)

    (at r1 central_warehouse)
    (at r2 entrance)

    (unloaded r1)
    ; not (busy r2)         not needed, in STRIPS they are false by default if not specified

    (at p1 entrance)
    (at p2 entrance)
    (at p3 entrance)
    (at p4 entrance)
    (at p5 entrance)
    
    (connected entrance l1)
    (connected l1 l2)
    (connected l2 central_warehouse)
)

(:goal (and
    (unit-has-content u1 scalpel)
    (unit-has-content u2 scalpel)
    (unit-has-content u2 tongue_depressor)

    (at-unit p1 u1)
    (at-unit p2 u1)
    (at-unit p3 u1)
    (at-unit p4 u1)
    (at-unit p5 u1)
))

)


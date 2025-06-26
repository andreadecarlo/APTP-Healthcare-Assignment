(define (problem problem1) (:domain healthcare)
(:objects 
    r1 - robot-box
    r2 - robot-patient
    
    b1 b2 b3 b4 b5 b6 - box

    u1 u2 u3 u4 u5 u6 - unit
    l1 l2 l3 l4 l5 - location

    p1 p2 p3 p4 p5 p6 - patient

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
    (at b4 central_warehouse)
    (at b5 central_warehouse)
    (at b6 central_warehouse)

    (empty-box b1)
    (empty-box b2)
    (empty-box b3)
    (empty-box b4)
    (empty-box b5)
    (empty-box b6)

    (at tongue_depressor central_warehouse)
    (at scalpel central_warehouse)

    (at u1 l1)
    (at u2 l2)
    (at u3 l2)
    (at u4 l3)
    (at u5 l4)
    (at u6 l5)

    (at r1 central_warehouse)
    (at r2 entrance)

    (unloaded r1)
    ; not (busy r2)         not needed, in STRIPS they are false by default if not specified

    (at p1 entrance)
    (at p2 entrance)
    (at p3 entrance)
    (at p4 entrance)
    (at p5 entrance)
    (at p6 entrance)
    
    (connected entrance l1)
    (connected l1 l2)
    (connected l2 l3)
    (connected l3 l4)
    (connected l4 l5)
    (connected l5 central_warehouse)

    (rob-carrier r1 c1)
    (capacity_predecessor capacity_0 capacity_1)
    (capacity_predecessor capacity_1 capacity_2)
    (capacity_predecessor capacity_2 capacity_3)
    (capacity c1 capacity_2)
)

(:goal (and
    (unit-has-content u1 scalpel)
    (unit-has-content u2 scalpel)
    (unit-has-content u2 tongue_depressor)
    (unit-has-content u3 scalpel)
    (unit-has-content u4 scalpel)
    (unit-has-content u5 scalpel)
    (unit-has-content u6 scalpel)

    (at-unit p1 u1)
    (at-unit p2 u2)
    (at-unit p3 u3)
    (at-unit p4 u4)
    (at-unit p5 u5)
    (at-unit p6 u6)
))

)


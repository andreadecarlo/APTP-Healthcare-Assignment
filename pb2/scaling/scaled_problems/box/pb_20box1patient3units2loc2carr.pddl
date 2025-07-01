(define (problem problem1) (:domain healthcare)
(:objects 
    r1 - robot-box
    r2 - robot-patient
    
    b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 - box
    c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 - content

    u1 u2 u3 - unit
    l1 l2 - location

    p1 - patient

    cr1 - carrier

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
    (at b7 central_warehouse)
    (at b8 central_warehouse)
    (at b9 central_warehouse)
    (at b10 central_warehouse)
    (at b11 central_warehouse)
    (at b12 central_warehouse)
    (at b13 central_warehouse)
    (at b14 central_warehouse)
    (at b15 central_warehouse)
    (at b16 central_warehouse)
    (at b17 central_warehouse)
    (at b18 central_warehouse)
    (at b19 central_warehouse)
    (at b20 central_warehouse)


    (at tongue_depressor central_warehouse)
    (at scalpel central_warehouse)

    (at c1 central_warehouse)
    (at c2 central_warehouse)
    (at c3 central_warehouse)
    (at c4 central_warehouse)
    (at c5 central_warehouse)
    (at c6 central_warehouse)
    (at c7 central_warehouse)
    (at c8 central_warehouse)
    (at c9 central_warehouse)
    (at c10 central_warehouse)

    (at u1 l1)
    (at u2 l2)
    (at u3 l2)

    (at r1 central_warehouse)
    (at r2 entrance)

    ;(unloaded r1)
    ; not (busy r2)         not needed, in STRIPS they are false by default if not specified

    (at p1 entrance)
    
    (connected entrance l1)
    (connected l1 l2)
    (connected l2 central_warehouse)

    (rob-carrier r1 cr1)
    (capacity_predecessor capacity_0 capacity_1)
    (capacity_predecessor capacity_1 capacity_2)
    (capacity_predecessor capacity_2 capacity_3)
    (capacity cr1 capacity_2)
)

(:goal (and
    (unit-has-content u1 c1)
    (unit-has-content u1 c2)
    (unit-has-content u1 c3)
    (unit-has-content u1 c4)
    (unit-has-content u1 c5)
    (unit-has-content u1 c6)
    (unit-has-content u1 c7)
    (unit-has-content u1 c8)
    (unit-has-content u1 c9)
    (unit-has-content u1 c10)

    (unit-has-content u2 c1)
    (unit-has-content u2 c2)
    (unit-has-content u2 c3)
    (unit-has-content u2 c4)
    (unit-has-content u2 c5)
    (unit-has-content u2 c6)
    (unit-has-content u2 c7)
    (unit-has-content u2 c8)
    (unit-has-content u2 c9)
    (unit-has-content u2 c10)

    (at-unit p1 u1)
))

)


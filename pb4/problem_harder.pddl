(define (problem problem4) (:domain healthcare)
    (:objects 
        r1 r2 - robot-box
        rp1 - robot-patient

        u1 u2 u3 - unit
        l1 l2 l3 l4 l5 - location

        c1 c2 c3 c4 c5 - content
        b1 b2 b3 b4 b5 b6 b7 b8 - box
        p1 p2 p3 p4 - patient

        cr1 cr2 - carrier

        cap_0 cap_1 cap_2 cap_3 cap_4 - capacity_number
    )

    (:init
        (at r1 central_warehouse)
        (at r2 central_warehouse)
        (at rp1 entrance)
        ; (at rp2 entrance)
        
        (rob-carrier r1 cr1)
        (rob-carrier r2 cr2)

        (available r1)
        (available r2)
        (available rp1)
        ; (available rp2)

        (at p1 entrance)
        (at p2 entrance)
        (at p3 entrance)
        (at p4 entrance)

        (connected entrance l1)
        (connected l1 l2)
        (connected l2 l3)
        (connected l3 l4)
        (connected central_warehouse l4)

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

        (at u1 l2)
        (at u2 l3)
        (at u3 l4)

        (at c1 central_warehouse)
        (at c2 central_warehouse)
        (at c3 central_warehouse)
        (at c4 central_warehouse)        
        (at c5 central_warehouse)
        
        (capacity_predecessor cap_0 cap_1)
        (capacity_predecessor cap_1 cap_2)
        (capacity_predecessor cap_2 cap_3)
        (capacity_predecessor cap_2 cap_4)
        (capacity cr1 cap_4)
        (capacity cr2 cap_4)
    )

    (:goal (and
        (unit-has-content u1 c1)
        (unit-has-content u1 c2)
        (unit-has-content u1 c3)
        (unit-has-content u1 c4)
        (unit-has-content u2 c1)
        (unit-has-content u2 c2)
        (unit-has-content u2 c3)
        (unit-has-content u2 c4)
        
        (at-unit p1 u1)
        (at-unit p2 u2)
    ))

    ;; Optional metric to minimize total-time
    (:metric minimize (total-time))
)
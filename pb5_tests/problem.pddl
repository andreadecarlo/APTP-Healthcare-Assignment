(define (problem problem4) (:domain healthcare)
    (:objects 
        r1 - robot_box
        r2 - robot_patient

        u1 u2 u3 - unit
        l1 l2 l3 - location

        b1 b2 b3 - box
        p1 p2 - patient

        c1 - carrier

        capacity_0 - capacity_number
        capacity_1 - capacity_number
        capacity_2 - capacity_number
        capacity_3 - capacity_number

    )

    (:init
        (at_robot r1 central_warehouse)
        (at c1 central_warehouse)
        (rob_carrier r1 c1)

        (at_robot r2 entrance)

        (available r1)
        (available r2)

        (at p1 entrance)
        (at p2 entrance)

        (connected central_warehouse l1)
        (connected l1 l2)
        (connected l2 l3)

        (connected entrance l1)

        (at b1 central_warehouse)
        (at b2 central_warehouse)
        (at b3 central_warehouse)

        (at u1 l1)
        (at u2 l2)

        (empty_box b1)
        (empty_box b2)
        (empty_box b3)

        (at scalpel central_warehouse)
        (at aspirin central_warehouse)
        (at bandage central_warehouse)        
        
        (capacity_predecessor capacity_0 capacity_1)
        (capacity_predecessor capacity_1 capacity_2)
        (capacity_predecessor capacity_2 capacity_3)
        (capacity c1 capacity_3)
    )

    (:goal (and
        (unit_has_content u1 scalpel)
        (unit_has_content u1 aspirin)
        (unit_has_content u2 bandage)
        (at_unit p1 u1)
    ))

    ;; Optional metric to minimize total-time
    (:metric minimize (total-time))
)
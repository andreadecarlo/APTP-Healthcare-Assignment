(define (domain healthcare)

(:requirements :strips :typing :durative-actions :disjunctive-preconditions :equality :negative-preconditions )

(:types
    location
	unit    - locatable
	content - locatable
	box     - locatable
	patient - locatable
	robot-box       - robot
	robot-patient   - robot
	robot           - locatable
	carrier         - locatable
	capacity_number - object
)

(:constants 
	central_warehouse - location
	entrance - location
	scalpel tongue_depressor aspirin bandage thermometer - content
)

(:predicates
    (at ?x - locatable ?l - location)		; x is at location
	(at-unit ?p - patient ?u - unit) 		; patient is at unit
    (connected ?l1 - location ?l2 - location) ; locations are connected

    (filled-with ?b - box ?c - content) 		; box is filled with content 
	(full ?b - box)

	(unit-has-box ?u - unit ?b - box)           ; unit has a box
    (unit-has-content ?u - unit ?c - content)   ; unit has specific content

    (rob-carrier ?r - robot-box ?c - carrier)          ; robot has a carrier
    (loaded ?c - carrier ?b - box)              ; carrier is carrying a box

    (capacity ?c - carrier ?n - capacity_number)
	(capacity_predecessor ?arg0 - capacity_number ?arg1 - capacity_number)

    (with-patient ?r - robot ?p - patient)     ; robot is with a patient
	(busy ?r - robot-patient)                  ; robot is busy with a patient
	
	(available ?r - robot)                     ; robot is available for actions
)


(:durative-action move
	:parameters (?r - robot ?from - location ?to - location)
	:duration (= ?duration 1)
	:condition (and 
		(at start (at ?r ?from))
		(at start (or (connected ?from ?to) (connected ?to ?from)))
		(at start (available ?r))

		(at start (not (= ?to central_warehouse)))
	)
	:effect (and 
		(at start (not (at ?r ?from)))
		(at start (not (available ?r)))
		(at end (at ?r ?to))
		(at end (available ?r))
	)
)

(:durative-action return_to_warehouse
	:parameters (?r - robot-box ?from - location ?to - location ?cr - carrier ?s - capacity_number)
	:duration (= ?duration 10)
	:condition (and 
		(at start (at ?r ?from))
		(at start (or (connected ?from ?to) (connected ?to ?from)))
		(at start (available ?r))
		
		(at start (= ?to central_warehouse))
		(at start (not (exists (?s1 - capacity_number)(capacity_predecessor ?s ?s1))))
	)
	:effect (and 
		(at start (not (at ?r ?from)))
		(at start (not (available ?r)))
		(at end (at ?r ?to))
		(at end (available ?r))
	)
)


(:durative-action fill
	:parameters (?r - robot-box ?b - box ?c - content ?l - location)
	:duration (= ?duration 2)
	:condition (and 
		(at start (at ?b ?l))
		(at start (at ?r ?l))
		(at start (at ?c ?l))
		(at start (not (full ?b)))
		(at start (available ?r))
		(at start (= ?l central_warehouse))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (filled-with ?b ?c))
		(at end (full ?b))
		(at end (available ?r))
	)
)

(:durative-action pick-up
	:parameters (?r - robot-box ?b - box ?l - location ?cr - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:duration (= ?duration 1.5)
	:condition (and 
		(at start (at ?b ?l))
		(at start (at ?r ?l))

		(at start (rob-carrier ?r ?cr))
		(at start (capacity_predecessor ?s1 ?s2))
		(at start (capacity ?cr ?s2))
		(at start (available ?r))
		(at start (= ?l central_warehouse))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at start (not (at ?b ?l)))
		(at end (loaded ?cr ?b))
		(at end (capacity ?cr ?s1))
		(at end (not (capacity ?cr ?s2)))
		(at end (available ?r))
	)
)

(:durative-action drop
	:parameters (?r - robot-box ?b - box ?l - location ?u - unit ?cr - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:duration (= ?duration 1.5)
	:condition (and
		(at start (at ?r ?l))
		(at start (at ?u ?l))

		(at start (rob-carrier ?r ?cr))
		(at start (loaded ?cr ?b))
		(at start (capacity_predecessor ?s1 ?s2))
		(at start (capacity ?cr ?s1))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (unit-has-box ?u ?b))
		(at end (at ?b ?l))
		(at end (not (loaded ?cr ?b)))
		(at end (capacity ?cr ?s2))
		(at end (not (capacity ?cr ?s1)))
		(at end (available ?r))
	)
)

(:durative-action empty
	:parameters (?r - robot-box ?b - box ?c - content ?u - unit ?l - location)
	:duration (= ?duration 2)
	:condition (and 
		(at start (at ?u ?l))
		(at start (at ?b ?l))
		(at start (at ?r ?l))
		(at start (unit-has-box ?u ?b))
		(at start (filled-with ?b ?c))
		(at start (full ?b))
		(at start (not (unit-has-content ?u ?c)))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (unit-has-content ?u ?c))
		(at end (not (filled-with ?b ?c)))
		(at end (not (full ?b)))
		(at end (at ?c ?l))
		(at end (available ?r))
	)
)

(:durative-action take-patient
	:parameters (?r - robot-patient ?p - patient ?l - location)
	:duration (= ?duration 3)
	:condition (and 
		(at start (at ?r ?l))
		(at start (at ?p ?l))
		(at start (not (busy ?r)))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (with-patient ?r ?p))
		(at end (busy ?r))
		(at end (available ?r))
	)
)

(:durative-action release-patient
	:parameters (?r - robot-patient ?p - patient ?l - location ?u - unit)
	:duration (= ?duration 2)
	:condition (and 
		(at start (at ?r ?l))
		(at start (at ?u ?l))
		(at start (with-patient ?r ?p))
		(at start (busy ?r))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (at ?p ?l))
		(at end (at-unit ?p ?u))
		(at end (not (with-patient ?r ?p)))
		(at end (not (busy ?r)))
		(at end (available ?r))
	)
)

)


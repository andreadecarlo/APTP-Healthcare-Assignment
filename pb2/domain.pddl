(define (domain healthcare)

(:requirements :strips :typing :negative-preconditions :existential-preconditions :disjunctive-preconditions :conditional-effects)

(:types
	location
	unit - locatable
	content - locatable
	box - locatable
	patient - locatable
	robot-box - robot
	robot-patient - robot
	robot - locatable
	carrier - locatable
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

	; (unloaded ?r - robot-box)               	; robot is empty
	(full ?b - box)
	(filled-with ?b - box ?c - content) 		; box is filled with content 
	
	(unit-has-box ?u - unit ?b - box)              ; unit has a box
	(unit-has-content ?u - unit ?c - content) ; unit has specific content

	(rob-carrier ?r - robot-box ?cr - carrier)          ; robot has a carrier
	(loaded ?cr - carrier ?b - box)          ; carrier is carrying a box
	(capacity ?cr - carrier ?n - capacity_number)
	(capacity_predecessor ?arg0 - capacity_number ?arg1 - capacity_number)


	(with-patient ?r - robot ?p - patient)     	; robot is with a patient
	(busy ?r - robot-patient)              		; robot is busy with a patient
)


; Both robot-box and robot-patient can move between connected locations
(:action move
	:parameters (?r - robot ?from - location ?to - location)
	:precondition (and 
		(at ?r ?from)
		(or (connected ?from ?to) (connected ?to ?from))
		(not (= ?to central_warehouse))		; !!ROBOT-PATIENT CANNOT MOVE TO CENTRAL WAREHOUSE
	)
	:effect (and 
		(at ?r ?to)
		(not (at ?r ?from))

		; carrier is linked to robot
		; (forall (?c - carrier) 
		; 	(when (rob-carrier ?r ?c) 
		; 		(and 
		; 			(at ?c ?to)
		; 			(not (at ?c ?from))
		; 		)
		; 	)
		; )
		
		; patient is linked to robot
		; (forall (?p - patient) 
		; 	(when (with-patient ?r ?p) 
		; 		(and (at ?p ?to)
		; 			(not (at ?p ?from))
		; 		)
		; 	)
		; )
	)
)

(:action fill
	:parameters (?r - robot-box ?b - box ?c - content ?l - location)
	:precondition (and 
		(at ?b ?l)
		(at ?r ?l)
		(at ?c ?l)
		(not (full ?b))
		(= ?l central_warehouse) ; content can only be filled in the central warehouse
	)
	:effect (and 
		(filled-with ?b ?c)
		(full ?b)
	)
)


; Robot-box can pick up a box from a location
(:action pick-up
	:parameters (?r - robot-box ?b - box ?l - location ?cr - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:precondition (and 
		(at ?b ?l)
		(at ?r ?l)

		(rob-carrier ?r ?cr)
		(capacity_predecessor ?s1 ?s2)
		(capacity ?cr ?s2)
	)
	:effect (and 
		(loaded ?cr ?b)
		(not (at ?b ?l))
		
		(capacity ?cr ?s1)
		(not (capacity ?cr ?s2))
	)
)



(:action drop
	:parameters (?r - robot-box ?b - box ?l - location ?u - unit ?cr - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:precondition (and
		(at ?r ?l)
		(at ?u ?l)

		(rob-carrier ?r ?cr)
		(loaded ?cr ?b)

		(capacity_predecessor ?s1 ?s2)
		(capacity ?cr ?s1)
	)
	:effect (and 
		(unit-has-box ?u ?b)
		(at ?b ?l)

		(not (loaded ?cr ?b))
		(capacity ?cr ?s2)
		(not (capacity ?cr ?s1))
	)
)


; Robot-box can empty a box filled with content causing the unit to have that content
(:action empty
	:parameters (?r - robot-box ?b - box ?c - content ?u - unit ?l - location)
	:precondition (and 
		(at ?u ?l)
		(at ?b ?l)
		(at ?r ?l)
		(unit-has-box ?u ?b)
		(filled-with ?b ?c)
	)
	:effect (and 
		(unit-has-content ?u ?c)
		(not (filled-with ?b ?c))
		(not (full ?b))
		(at ?c ?l)
	)
)


(:action take-patient
	:parameters (?r - robot-patient ?p - patient ?l - location)
	:precondition (and 
		(at ?r ?l)
		(at ?p ?l)
		(not (busy ?r))
	)
	:effect (and 
		(with-patient ?r ?p)
		(busy ?r)
	)
)

(:action release-patient
	:parameters (?r - robot-patient ?p - patient ?l - location ?u - unit)
	:precondition (and 
		(at ?r ?l)
		(at ?u ?l)
		(with-patient ?r ?p)
		(busy ?r)
	)

	:effect (and 
		(at ?p ?l)
		(at-unit ?p ?u)
		
		(not (with-patient ?r ?p))
		(not (busy ?r))
	)
)

(:action return-to-warehouse
	:parameters (?r - robot-box ?from - location ?cr - carrier ?s - capacity_number)
	:precondition (and 
		(at ?r ?from)

		(rob-carrier ?r ?cr)
		(not (exists (?s0 - capacity_number) (capacity_predecessor ?s0 ?s)))
		(or (connected ?from central_warehouse) (connected central_warehouse ?from))
		(not (at ?r central_warehouse))
	)
	:effect (and 
		(at ?r central_warehouse)
		(not (at ?r ?from))
	)
)
)
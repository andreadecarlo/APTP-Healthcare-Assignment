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

	(filled-with ?b - box ?c - content) 		; box is filled with content 
	(empty-box ?b - box)               			; box is empty
	
	(unit-has-content ?u - unit ?c - content) ; unit has specific content
	(unit-has-box ?u - unit ?b - box)              ; unit has a box
	
	(loaded ?c - carrier ?b - box)          ; carrier is carrying a box
	; (unloaded ?r - robot-box)               	; robot is empty

	(capacity ?c - carrier ?n - capacity_number)
	(capacity_predecessor ?arg0 - capacity_number ?arg1 - capacity_number)

	(rob-carrier ?r - robot-box ?c - carrier)          ; robot has a carrier

	(with-patient ?r - robot ?p - patient)     ; robot is with a patient
	(busy ?r - robot-patient)               					; robot is busy with a patient

	(connected ?l1 - location ?l2 - location) ; locations are connected
)


; (:functions
; 	(max_load_capacity ?c - carrier) - number ; max load capacity of a carrier
; 	(num_box_carried ?c - carrier) - number ; box carried by a carrier
; )

;define actions here
(:action fill
	:parameters (?r - robot-box ?b - box ?c - content ?l - location)
	:precondition (and 
		(at ?b ?l)
		(at ?r ?l)
		(at ?c ?l)
		(empty-box ?b)
	)
	:effect (and 
		(filled-with ?b ?c)
		(not (empty-box ?b))
	)
)

(:action empty
	:parameters (?r - robot-box ?b - box ?c - content ?u - unit ?l - location)
	:precondition (and 
		(at ?u ?l)
		(at ?b ?l)
		(at ?r ?l)
		(unit-has-box ?u ?b)
		(filled-with ?b ?c)
		(not (empty-box ?b))
		(not (unit-has-content ?u ?c))
	)
	:effect (and 
		(unit-has-content ?u ?c)
		(not (filled-with ?b ?c))
		(empty-box ?b)
		(at ?c ?l)
	)
)

(:action pick-up
	:parameters (?r - robot-box ?b - box ?l - location ?c - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:precondition (and 
		(at ?b ?l)
		(at ?r ?l)
		(at ?c ?l)
		(rob-carrier ?r ?c)
		(capacity_predecessor ?s1 ?s2)
		(capacity ?c ?s2)
	)
	:effect (and 
		(loaded ?c ?b)
		(not (at ?b ?l))
		(capacity ?c ?s1)
		(not (capacity ?c ?s2))
	)
)

(:action move
	:parameters (?r - robot ?from - location ?to - location)
	:precondition (and 
		(at ?r ?from)
		(or (connected ?from ?to) (connected ?to ?from))
		(not (= ?to central_warehouse))
	)
	:effect (and 
		(at ?r ?to)
		(not (at ?r ?from))

		(forall (?c - carrier) 
			(and 
				(when (rob-carrier ?r ?c) 
					(and 
						(at ?c ?to)
						(not (at ?c ?from))
					)
				)
				(forall (?b - box) 
					(when (and (rob-carrier ?r ?c) (loaded ?c ?b))
						(and (at ?b ?to)
							(not (at ?b ?from))
						)
					)
				)
			)
		)

		

		(forall (?p - patient) 
			(when (with-patient ?r ?p) 
				(and (at ?p ?to)
					(not (at ?p ?from))
				)
			)
		)
	)
)


(:action drop
		:parameters (?r - robot-box ?b - box ?l - location ?u - unit ?c - carrier ?s1 - capacity_number ?s2 - capacity_number)
		:precondition (and
			(at ?r ?l)
			(at ?u ?l)
			(at ?c ?l)
			(rob-carrier ?r ?c)
			(loaded ?c ?b)
			(capacity_predecessor ?s1 ?s2)
			(capacity ?c ?s1)
		)
		:effect (and 
			(unit-has-box ?u ?b)
			(at ?b ?l)
			(not (loaded ?c ?b))
			(capacity ?c ?s2)
			(not (capacity ?c ?s1))
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
		(at ?p ?l)
		(at ?u ?l)
		(with-patient ?r ?p)
		(busy ?r)
	)

	:effect (and 
		(not (with-patient ?r ?p))
		(not (busy ?r))
		(at-unit ?p ?u)
	)
)

(:action return-to-warehouse
	:parameters (?r - robot-box ?from - location ?c - carrier ?s - capacity_number)
	:precondition (and 
		(at ?r ?from)
		(at ?c ?from)
		(rob-carrier ?r ?c)
		(not (exists (?s0 - capacity_number) (capacity_predecessor ?s0 ?s)))
		(or (connected ?from central_warehouse) (connected central_warehouse ?from))
		(not (at ?r central_warehouse))
	)
	:effect (and 
		(at ?r central_warehouse)
		(not (at ?r ?from))
		(at ?c central_warehouse)
		(not (at ?c ?from))
	)
)
)
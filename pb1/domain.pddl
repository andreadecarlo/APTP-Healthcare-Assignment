(define (domain healthcare)

(:requirements :strips :typing :negative-preconditions :universal-preconditions)

(:types
	location
	unit - locatable
	content - locatable
	box - locatable
	patient - locatable
	robot-box - robot
	robot-patient - robot
	robot - locatable
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
	
	(loaded ?r - robot ?b - box)          ; robot is carrying a box
	(unloaded ?r - robot-box)               	; robot is empty

	(with-patient ?r - robot ?p - patient)     ; robot is with a patient
	(busy ?r - robot-patient)               					; robot is busy with a patient

	(connected ?l1 - location ?l2 - location) ; locations are connected
)


; (:functions)

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
		(not (unit-has-content ?u ?c))			; necessary?
	)
	:effect (and 
		(unit-has-content ?u ?c)
		(not (filled-with ?b ?c))
		(empty-box ?b)
		(at ?c ?l)
	)
)

(:action pick-up
	:parameters (?r - robot-box ?b - box ?l - location)
	:precondition (and 
		(at ?b ?l)
		(at ?r ?l)
		(unloaded ?r)
	)
	:effect (and 
		(loaded ?r ?b)
		(not (unloaded ?r))
		(not (at ?b ?l))
	)
)

(:action move
	:parameters (?r - robot ?from - location ?to - location)
	:precondition (and 
		(at ?r ?from)
		(or (connected ?from ?to) (connected ?to ?from))
	)
	:effect (and 
		(at ?r ?to)
		(not (at ?r ?from))

		(forall (?b - box) 
			(when (loaded ?r ?b) 
				(and (at ?b ?to)
					(not (at ?b ?from))
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

(:action deliver
		:parameters (?r - robot-box ?b - box ?l - location ?u - unit)
		:precondition (and
			(at ?r ?l)
			(at ?u ?l)
			(at ?b ?l)

			(loaded ?r ?b)
		)
		:effect (and 
			(unit-has-box ?u ?b)
			(not (loaded ?r ?b))
			(unloaded ?r)
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
)
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
)

(:predicates
	(at ?x - locatable ?l - location)			; x is at location
	(at-unit ?p - patient ?u - unit) 			; patient is at unit
	(connected ?l1 - location ?l2 - location)	; locations are connected
	
	(loaded ?r - robot ?b - box)          		; robot is carrying a box
	(unloaded ?r - robot-box)               	; robot is empty
	(full ?b - box)
	(filled-with ?b - box ?c - content) 		; box is filled with content 
	(unit-has-box ?u - unit ?b - box)           ; unit has a box
	(unit-has-content ?u - unit ?c - content) 	; unit has specific content
	
	(with-patient ?r - robot ?p - patient)     	; robot is with a patient
	(busy ?r - robot-patient)           		; robot is busy with a patient
)


; (:functions)


; Both robot-box and robot-patient can move between connected locations
(:action move
	:parameters (?r - robot ?from - location ?to - location)
	:precondition (and 
		(at ?r ?from)
		(or (connected ?from ?to) (connected ?to ?from))
	)
	:effect (and 
		(at ?r ?to)
		(not (at ?r ?from))
	)
)

; Robot-box can fill a box with content
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

; Robot-box can pick up a box from a location
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


; Robot-box can deliver a box to a unit at a location
(:action deliver
		:parameters (?r - robot-box ?b - box ?l - location ?u - unit)
		:precondition (and
			(at ?r ?l)
			(at ?u ?l)

			(loaded ?r ?b)
		)
		:effect (and 
			(at ?b ?l)
			(unit-has-box ?u ?b)
			
			(not (loaded ?r ?b))
			(unloaded ?r)
		)
)

; Robot-patient can take a patient from a location, causing the robot to be busy
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

; Robot-patient can release a patient at a location, causing the robot to be no longer busy
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
)
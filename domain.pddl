(define (domain healthcare_1)

(:requirements :strips :typing)

(:types
	location
	unit
	robot-box - robot
	robot-escort - robot
	content
	box
	patient
)

(:constants 
	central_warehouse - location
	entrance - location
	scalpel tongue_depressor aspirin bandage thermometer - content
)

(:predicates
	(unit-at ?u - unit ?l - location)       ; unit is at location
	(box-at ?b - box ?l - location)         ; box is at location
	(robot-at ?r - robot ?l - location) ; robot is at location
	(content-at ?c - content ?l - location) ; content is at location

	(filled-with ?b - box ?c - content) 		; box is filled with content 
	(empty-box ?b - box)               			; box is empty
	
	(unit-has-content ?u - unit ?c - content) ; unit has specific content
	(unit-has-box ?u - unit ?b - box)              ; unit has a box
	
	(loaded ?r - robot-box ?b - box)          ; robot is carrying a box
	(unloaded ?r - robot-box)               	; robot is empty
)


; (:functions)

;define actions here
(:action fill
		:parameters (?r - robot-box ?b - box ?c - content ?l - location)
		:precondition (and 
			(box-at ?b ?l)
			(robot-at ?r ?l)
			(content-at ?c ?l)
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
			(unit-at ?u ?l)
			(box-at ?b ?l)
			(robot-at ?r ?l)
			(unit-has-box ?u ?b)
			(filled-with ?b ?c)
			(not (empty-box ?b))
			(not (unit-has-content ?u ?c))
		)
		:effect (and 
			(unit-has-content ?u ?c)
			(not (filled-with ?b ?c))
			(empty-box ?b)
			(content-at ?c ?l)
		)
)

(:action pick-up
		:parameters (?r - robot-box ?b - box ?l - location)
		:precondition (and 
			(box-at ?b ?l)
			(robot-at ?r ?l)
			(unloaded ?r)
		)
		:effect (and 
			(loaded ?r ?b)
			(not (unloaded ?r))
			(not (box-at ?b ?l))
		)
)

(:action move
		:parameters (?r - robot-box ?from - location ?to - location)
		:precondition (and 
			(robot-at ?r ?from)
		)
		:effect (and 
			(robot-at ?r ?to)
			(not (robot-at ?r ?from))
			(forall (?b - box) 
				(when (loaded ?r ?b) 
					(box-at ?b ?to)
					(not (box-at ?b ?from))
				)
			)
		)
)

(:action deliver
		:parameters (?r - robot-box ?b - box ?l - location ?u - unit)
		:precondition (and 
			(robot-at ?r ?l)
			(unit-at ?u ?l)
			(box-at ?b ?l)

			(loaded ?r ?b)
		)
		:effect (and 
			(unit-has-box ?u ?b)
			(not (loaded ?r ?b))
			(unloaded ?r)
		)
)





)
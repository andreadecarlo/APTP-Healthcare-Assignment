(define (domain healthcare_fluents)

(:requirements :strips :typing :negative-preconditions :quantified-preconditions :fluents :disjunctive-preconditions :conditional-effects)

(:types
	location
	unit
	robot-box - robot
	robot_patient - robot
	content
	box
	patient
	carrier
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
	(patient-at ?p - patient ?l - location) ; patient is at location
	(patient-at-unit ?p - patient ?u - unit) ; patient is at unit
	(carrier-at ?c - carrier ?l - location) ; carrier is at location

	(filled-with ?b - box ?c - content) 		; box is filled with content 
	(empty-box ?b - box)               			; box is empty
	
	(unit-has-content ?u - unit ?c - content) ; unit has specific content
	(unit-has-box ?u - unit ?b - box)              ; unit has a box
	
	(loaded ?c - carrier ?b - box)          ; carrier is carrying a box
	; (unloaded ?r - robot-box)               	; robot is empty

	(rob-carrier ?r - robot-box ?c - carrier)          ; robot has a carrier

	(with-patient ?r - robot_patient ?p - patient)     ; robot is with a patient
	(busy ?r - robot_patient)               					; robot is busy with a patient

	(connected ?l1 - location ?l2 - location) ; locations are connected
)


(:functions
	(max_load_capacity ?c - carrier) - number ; max load capacity of a carrier
	(num_box_carried ?c - carrier) - number ; box carried by a carrier
)

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
	:parameters (?r - robot-box ?b - box ?l - location ?c - carrier)
	:precondition (and 
		(box-at ?b ?l)
		(robot-at ?r ?l)
		(rob-carrier ?r ?c)
		(carrier-at ?c ?l)
		; (unloaded ?r)
		(> (max_load_capacity ?c) 0)		; can load boxes in the carrier up to carrier maximum capacity
	)
	:effect (and 
		(loaded ?c ?b)
		; (not (unloaded ?r))
		(not (box-at ?b ?l))
		(decrease (max_load_capacity ?c) 1)
		(increase (num_box_carried ?c) 1)
	)
)

(:action move
	:parameters (?r - robot-box ?from - location ?to - location ?c - carrier)
	:precondition (and 
		(robot-at ?r ?from)
		(or (connected ?from ?to) (connected ?to ?from))
		(rob-carrier ?r ?c)
		(carrier-at ?c ?from)
		(not (= ?to central_warehouse))
	)
	:effect (and 
		(robot-at ?r ?to)
		(not (robot-at ?r ?from))
		(carrier-at ?c ?to)
		(not (carrier-at ?c ?from))
	)
)

(:action move-without-patient
  :parameters (?r - robot_patient ?from - location ?to - location)
  :precondition (and 
    (robot-at ?r ?from)
    (not (busy ?r))
    (or (connected ?from ?to) (connected ?to ?from))
  )
  :effect (and 
    (robot-at ?r ?to)
    (not (robot-at ?r ?from))
  )
)

; (:action move-loaded
;   :parameters (?r - robot-box ?b - box ?from - location ?to - location)
;   :precondition (and 
;     (robot-at ?r ?from)
;     (loaded ?r ?b)
;     (or (connected ?from ?to) (connected ?to ?from))
;   )
;   :effect (and 
;     (robot-at ?r ?to)
;     (not (robot-at ?r ?from))
;     (box-at ?b ?to)
;     (not (box-at ?b ?from))
;   )
; )


(:action deliver
		:parameters (?r - robot-box ?b - box ?l - location ?u - unit ?c - carrier)
		:precondition (and
			(robot-at ?r ?l)
			(unit-at ?u ?l)
			(rob-carrier ?r ?c)
			(carrier-at ?c ?l)
			(loaded ?c ?b)
		)
		:effect (and 
			(unit-has-box ?u ?b)
			(box-at ?b ?l)
			(not (loaded ?c ?b))
			;  (unloaded ?r)
			(increase (max_load_capacity ?c) 1)
			(decrease (num_box_carried ?c) 1)
		)
)

(:action take-patient
	:parameters (?r - robot_patient ?p - patient ?l - location)
	:precondition (and 
		(robot-at ?r ?l)
		(patient-at ?p ?l)
		(not (busy ?r))
	)
	:effect (and 
		(with-patient ?r ?p)
		(busy ?r)
	)
)

(:action move-with-patient
	:parameters (?r - robot_patient ?p - patient ?from - location ?to - location)
	:precondition (and 
		(robot-at ?r ?from)
		(patient-at ?p ?from)
		(with-patient ?r ?p)
		(or (connected ?from ?to) (connected ?to ?from))
	)
	:effect (and 
		(robot-at ?r ?to)
		(patient-at ?p ?to)
		(not (robot-at ?r ?from))
		(not (patient-at ?p ?from))
	)
)

(:action release-patient
	:parameters (?r - robot_patient ?p - patient ?l - location ?u - unit)
	:precondition (and 
		(robot-at ?r ?l)
		(patient-at ?p ?l)
		(unit-at ?u ?l)
		(with-patient ?r ?p)
		(busy ?r)
	)

	:effect (and 
		(not (with-patient ?r ?p))
		(not (busy ?r))
		(patient-at-unit ?p ?u)
	)
)

(:action return-to-warehouse
	:parameters (?r - robot-box ?from - location ?c - carrier)
	:precondition (and 
		(robot-at ?r ?from)
		(carrier-at ?c ?from)
		(rob-carrier ?r ?c)
		(= (num_box_carried ?c) 0)
		(or (connected ?from central_warehouse) (connected central_warehouse ?from))
		(not (= ?from central_warehouse))
	)
	:effect (and 
		(robot-at ?r central_warehouse)
		(not (robot-at ?r ?from))
		(carrier-at ?c central_warehouse)
		(not (carrier-at ?c ?from))
	)
)
)
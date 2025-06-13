(define (domain healthcare)

(:requirements :strips :typing :durative-actions :adl)

(:types
    location
	unit    - locatable
	content - locatable
	box     - locatable
	patient - locatable
	robot_box       - robot
	robot_patient   - robot
	robot	- object
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
	(at_robot ?r - robot ?l - location)
	(at_unit ?p - patient ?u - unit) 		; patient is at unit

    (connected ?l1 - location ?l2 - location) ; locations are connected

    (filled_with ?b - box ?c - content) 		; box is filled with content 
	(empty_box ?b - box)               			; box is empty

    (unit_has_content ?u - unit ?c - content)   ; unit has specific content
	(unit_has_box ?u - unit ?b - box)           ; unit has a box

    (rob_carrier ?r - robot_box ?c - carrier)          ; robot has a carrier
    (loaded ?c - carrier ?b - box)              ; carrier is carrying a box

    (capacity ?c - carrier ?n - capacity_number)
	(capacity_predecessor ?arg0 - capacity_number ?arg1 - capacity_number)

    (with_patient ?r - robot ?p - patient)     ; robot is with a patient
	(busy ?r - robot_patient)                  ; robot is busy with a patient
	
	(available ?r - robot)                     ; robot is available for actions
)

(:durative-action move_carrier
	:parameters (?r - robot_box ?c - carrier ?from - location ?to - location)
	:duration (= ?duration 5)
	:condition (and 
		(at start (at_robot ?r ?from))
		(at start (rob_carrier ?r ?c))
		(at start (or (connected ?from ?to) (connected ?to ?from)))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (at_robot ?r ?from)))
		(at start (not (at ?c ?from)))
		(at start (not (available ?r)))
		(at end (at_robot ?r ?to))
		(at end (at ?c ?to))
		(at end (available ?r))
	)
)

(:durative-action move_robot
    :parameters (?r - robot_patient ?from - location ?to - location)
    :duration (= ?duration 3)
    :condition (and
        (at start (at_robot ?r ?from))
        (at start (or (connected ?from ?to) (connected ?to ?from)))
        (at start (available ?r))
    )
    :effect (and
        (at start (not (at_robot ?r ?from)))
        (at start (not (available ?r)))
        (at end (at_robot ?r ?to))
        (at end (available ?r))
    )
)

(:durative-action fill
	:parameters (?r - robot_box ?b - box ?c - content ?l - location)
	:duration (= ?duration 2)
	:condition (and 
		(at start (at ?b ?l))
		(at start (at_robot ?r ?l))
		(at start (at ?c ?l))
		(at start (empty_box ?b))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (filled_with ?b ?c))
		(at end (not (empty_box ?b)))
		(at end (available ?r))
	)
)

(:durative-action pick_up
	:parameters (?r - robot_box ?b - box ?l - location ?c - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:duration (= ?duration 1.5)
	:condition (and 
		(at start (at ?b ?l))
		(at start (at_robot ?r ?l))
		(at start (at ?c ?l))
		(at start (rob_carrier ?r ?c))
		(at start (capacity_predecessor ?s1 ?s2))
		(at start (capacity ?c ?s2))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (loaded ?c ?b))
		(at start (not (at ?b ?l)))
		(at end (capacity ?c ?s1))
		(at end (not (capacity ?c ?s2)))
		(at end (available ?r))
	)
)

(:durative-action drop
	:parameters (?r - robot_box ?b - box ?l - location ?u - unit ?c - carrier ?s1 - capacity_number ?s2 - capacity_number)
	:duration (= ?duration 1.5)
	:condition (and
		(at start (at_robot ?r ?l))
		(at start (at ?u ?l))
		(at start (at ?c ?l))
		(at start (rob_carrier ?r ?c))
		(at start (loaded ?c ?b))
		(at start (capacity_predecessor ?s1 ?s2))
		(at start (capacity ?c ?s1))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (unit_has_box ?u ?b))
		(at end (at ?b ?l))
		(at end (not (loaded ?c ?b)))
		(at end (capacity ?c ?s2))
		(at end (not (capacity ?c ?s1)))
		(at end (available ?r))
	)
)

(:durative-action empty
	:parameters (?r - robot_box ?b - box ?c - content ?u - unit ?l - location)
	:duration (= ?duration 2)
	:condition (and 
		(at start (at ?u ?l))
		(at start (at ?b ?l))
		(at start (at_robot ?r ?l))
		(at start (unit_has_box ?u ?b))
		(at start (filled_with ?b ?c))
		(at start (not (empty_box ?b)))
		(at start (not (unit_has_content ?u ?c)))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (unit_has_content ?u ?c))
		(at end (not (filled_with ?b ?c)))
		(at end (empty_box ?b))
		(at end (at ?c ?l))
		(at end (available ?r))
	)
)

(:durative-action take_patient
	:parameters (?r - robot_patient ?p - patient ?l - location)
	:duration (= ?duration 3)
	:condition (and 
		(at start (at_robot ?r ?l))
		(at start (at ?p ?l))
		(at start (not (busy ?r)))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (with_patient ?r ?p))
		(at end (busy ?r))
		(at end (available ?r))
	)
)

(:durative-action release_patient
	:parameters (?r - robot_patient ?p - patient ?l - location ?u - unit)
	:duration (= ?duration 3)
	:condition (and 
		(at start (at_robot ?r ?l))
		(at start (at ?u ?l))
		(at start (with_patient ?r ?p))
		(at start (busy ?r))
		(at start (available ?r))
	)
	:effect (and 
		(at start (not (available ?r)))
		(at end (not (with_patient ?r ?p)))
		(at end (not (busy ?r)))
		(at end (at_unit ?p ?u))
		(at end (available ?r))
	)
)

)


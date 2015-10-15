;; person structure and functions

(defstruct person 
	(name nil) 
	(parents nil) 
	(children nil) 
	(spouse nil))

(defun create-person (name parentstructs)
	(when (not (listp parentstructs))
		(error "Parentstructs is not a list."))
	(let ((p (make-person)))
		(setf (person-name p) name)
		(setf (person-parents p) (copy-list parentstructs))
	p))

;function to add new child
(defun add-children (p newchild) 
	(nconc (person-children p) (list newchild))
	)

;function to add parent
(defun add-parent (p newparent)
	(nconc (person-parents p) (list newparent))
	)

;function to set parents
(defun set-parents (p parent1 parent2)
	(setf (person-parents p) (list parent1 parent2))
	)

;function to add spouse
(defun add-spouse (p spouse)
	(nconc (person-spouse p) (list spouse))
	)



;; main function
(defun family ()


	)

;; function to handle input
;(defun handle-line ()
;	(let ((a ))
;		(setf a (read __ ))
;		(format t " " _ _ _)
;		))

;; E query
(defun E ()


	)

;; function to check if person is part of Adam and Eve generation
(defun isAdamAndEve ()


	)

;; R query
(defun R ()


	)

;; boolean for spouse
(defun isSpouse ((person p1) (person p2))
	(member (person-spouse p1) (person-spouse p2))
	)


;; boolean for parent
(defun isParent ((person p1) (person p2))
	(if (not (eq p1 p2))
	(member p1 (person-parents p2))
	)


;;boolean for sibling
(defun isSibling ((person p1) (person p2))


	)

;; boolean for ancestor
(defun isAncestor ()

	
	)

;; recursive method for isAncestor
(defun checkParents ()

	
	)

;; boolean for cousin
(defun isCousin ()

	
	)

;; boolean for relative
(defun isRelative ()

	
	)

;; X query
(defun X ()


	)

;; W query
(defun W ()


	)

;; collects all people who are siblings of a person
(defun getSiblings ()


	)

;; collects all people who are ancestors of a person
(defun getAncestors ()


	)

;; collects all people who are relatives of a person
(defun getRelatives ()


	)

;; collects all people who are not related to a person
(defun getStrangers ()


	)
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
	(setf (person-children p) (nconc (person-children p) (list newchild)))
	)

;function to add parent
(defun add-parent (p newparent)
	(setf (person-parents p) (nconc (person-parents p) (list newparent)))
	)

;function to set parents
(defun set-parents (p parent1 parent2)
	(setf (person-parents p) (list parent1 parent2))
	)

;function to add spouse
(defun add-spouse (p spouse)
	(setf (person-spouse p) (nconc (person-spouse p) (list spouse)))
	)

(defvar familytree (make-hash-table))

;; main function
(defun family ()


	)

;; function to handle input
;(defun handle-line ()
;	(let ((a ))
;		(setf a (read __ ))
;		(format t " " _ _ _)
;		))

(defun openfile (with-open-file (str *STANDARD-INPUT*
                     :direction :INPUT
                     ;:if-exists <if-exists>
                     :if-does-not-exist :ERROR)
  		(loop for line = (read-line str nil)
  		while line do (line)
		)
	)
)

;; E query
(defun E ()


	)

(defun checkOrAddToGraph (nodeName p1 p2)
	

	)

;; function to check if person is part of Adam and Eve generation
(defun isAdamAndEve (name)
	(if ((not (member name (person-parents (gethash name familytree)) ) ))
		nil 
		t)
	)

;; R query
(defun R (p1 p2)
	(setf per1 (gethash 'p1 familytree))
	(setf per2 (gethash 'p2 familytree))

	(cond 
		((or (equalp per1 nil) (equalp per2 nil)) "Unrelated")

		((isSpouse per1 per2) "Spouse")

		((isParent per1 per2) "Parent")

		((isSibling per1 per2) "Sibling")

		((isAncestor per1 per2) "Ancestor")

		((isRelative per1 per2) (setf ancestors (getAncestors per1)) "Relative")

		(t "Unrelated")
	)
)

;; boolean for spouse
(defun isSpouse (p1 p2)
	(if (not (member (person-name p1) (person-spouse p2)))
		nil 
		t)
)

;; boolean for parent
(defun isParent (p1 p2)
	(if (equalp (person-name p1) (person-name p2)) (return-from nil))

	(if (not (member (person-name p1) (person-parents p2)))
		nil 
		t)
	)

;; boolean for sibling
(defun isSibling (p1 p2)
	(if (isAdamAndEve (person-name p1) (person-name p2)) nil)

	(setf person1parents (person-parents p1))
	(setf person2parents (person-parents p2))
	(sort 'person1parents)
	(sort 'person2parents)

	(equalp person1parents person2parents)

)

;; boolean for ancestor
(defun isAncestor (p1 p2)
	;; check for same name first...

	(if (checkParents(p1 p2))
		(return-from t) 
		(return-from nil)
	)

	(cond 
		((and(equalp (person-name p1) (person-name p2)) (isAdamAndEve (person-name p1)))) 
		(checkParents p1 p2)
		(t nil)
		)
)

;; recursive method for isAncestor
(defun checkParents (target p)
	(if (isAdamAndEve((person-name p)))
		(return-from nil) 
		(if ((equalp (first (person-parents p)) (person-name target)))
			(return-from t) 
			(if ((equalp (second (person-parents p)) (person-name target)))
				(return-from t) 
				(if ((checkParents(target (gethash (first (person-parents p)) familytree))))
					(return-from t) 
					(if ((checkParents(target (gethash (second (person-parents p)) familytree))))
						(return-from t) 
						(return-from nil)
					)
				)
			)
		)
	)
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
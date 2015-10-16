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

(defun openfile() with-open-file (str *STANDARD-INPUT*
                     :direction :INPUT
                     ;:if-exists <if-exists>
                     :if-does-not-exist :ERROR)
  		(loop for line = (read-line str nil)
  		while line do (line)
		)
	)

;; E query
(defun E (name1 name2 name3)
	(checkOrAddToGraph name1 name1 name1)
	(checkOrAddToGraph name2 name2 name2)
	(checkOrAddToGraph name3 name1 name2)

	(add-spouse (gethash name1 familytree) name2)
	(add-spouse (gethash name2 familytree) name1)
)

(defun checkOrAddToGraph (nodeName par1 par2)
	(cond
		((not (member nodeName familytree))
			(progn (create-person nodeName (par1 par2)) (setf (gethash nodeName familytree) (nodeName par1 par2))))
		((isAdamAndEve nodeName) (setf (person-parents nodeName) (par1 par2)))
		((not (equalp par1 par2)) (progn (add-children p1 nodeName) (add-children p2 nodeName)))
	)
)

		
;; function to check if person is part of Adam and Eve generation
(defun isAdamAndEve (name)
	(if (not (member name (person-parents (gethash name familytree))))
		nil 
		t)
)

;; R query
(defun R (p1 p2)
	(setf per1 (gethash p1 familytree))
	(setf per2 (gethash p2 familytree))

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
	(if (equalp (person-name p1) (person-name p2)) nil)

	(if (not (member (person-name p1) (person-parents p2)))
		nil 
		t)
)

;; boolean for sibling
(defun isSibling (p1 p2)
	(if (isAdamAndEve (person-name p1)) nil)
	(if (isAdamAndEve (person-name p2)) nil)

	(setf person1parents (person-parents p1))
	(setf person2parents (person-parents p2))
	(setf person1parents (sort person1parents #'string<))
	(setf person2parents (sort person2parents #'string<))

	(equalp person1parents person2parents)
)

;; boolean for ancestor
(defun isAncestor (p1 p2)
	(cond 
		((and (equalp (person-name p1) (person-name p2)) (isAdamAndEve (person-name p1))) t) 
		((checkParents p1 p2) t) 
		(t nil)
	)
)

;; recursive method for isAncestor
(defun checkParents (target p)
	(if (isAdamAndEve (person-name p))
		nil 
		(if (equalp (first (person-parents p)) (person-name target))
			t 
			(if (equalp (second (person-parents p)) (person-name target))
				t  
				(if (checkParents target (gethash (first (person-parents p)) familytree))
					t  
					(if (checkParents target (gethash (second (person-parents p)) familytree))
						t 
						nil
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
(defun isRelative (p1 p2)
	(setf p1rels (getAncestors p1))
	(setf p2rels (getAncestors p2))

	(loop for x in p1rels do (
		loop for y in p2rels do (
			(if (equalp x y) t)
		)
	))
	nil
)

;; X query
(defun X (name1 relation name2)
	(setf p1 (gethash name1 familytree))
	(setf p2 (gethash name2 familytree))

	(if (or (eq p1 nil) (eq p2 nil))
		(error "Person not in family tree.")
	)

	(setf answer "")
	(cond 
		((equalp relation 'spouse) (setf answer (if (isSpouse p1 p2) "Yes" "No")))
		((equalp relation 'parent) (setf answer (if (isParent p1 p2) "Yes" "No")))
		((equalp relation 'sibling) (setf answer (if (isSibling p1 p2) "Yes" "No")))
		((equalp relation 'ancestor) (setf answer (if (isAncestor p1 p2) "Yes" "No")))
		((equalp relation 'cousin) (setf answer (if (isCousin p1 p2) "Yes" "No")))
		((equalp relation 'relative) (setf answer (if (isRelative p1 p2) "Yes" "No")))
		((equalp relation 'unrelated) (setf answer (if (not (isRelative p1 p2)) "Yes" "No")))
	)
	answer
)

;; W query
(defun W (relation name)
	(setf person (gethash name familytree))
	(setf wPeople ())

	(if (eq person nil) 
		(error "Person not in family tree.")
	)

	(cond
		((equalp relation 'spouse) (nconc wPeople (person-spouse person)))
		((equalp relation 'parent) (if (isAdamAndEve person) (nconc wPeople person) (else (nconc wPeople (person-parents person)))))
		((equalp relation 'sibling) (nconc wPeople (getSiblings person)))
		((equalp relation 'ancestor) (nconc wPeople (getAncestors person)))
		;; add cousin relationship here
		((equalp relation 'relative) (nconc wPeople (getRelatives person)))
		((equalp relation 'unrelated) (nconc wPeople (getStrangers person)))
	)

	(setf wPeople (sort wPeople #'string<))
	wPeople
)

;; collects all people who are siblings of a person
(defun getSiblings (p)
	(setf siblings ())

	(loop for entry in familytree
		(if (isSibling p (gethash entry familytree))
			(setf siblings (nconc siblings (person-name entry)))
		)
	)
	siblings
)

;; collects all people who are ancestors of a person
(defun getAncestors (p)
	(setf ancestrs ())
	(loop for entry in familytree
		(if (checkParents (gethash entry familytree) p)
			(setf ancestrs (nconc ancestrs (person-name entry)))
		)
	)
	;cond for if no ancestors
	(if (eq ancestrs nil)
		(setf ancestrs (person-name p))
	)
	;return ancestors
	ancestrs
)

;; collects all people who are relatives of a person
(defun getRelatives (p)
	(setf rels ())
	(loop for entry in familytree
		(if (isRelative entry p)
			(setf rels (nconc rels (person-name entry)))
		)
	)
	rels
)

;; collects all people who are not related to a person
(defun getStrangers (p)
	(setf strange ())
	(loop for entry in familytree
		(if (and (not (isRelative entry p)) (not (isSpouse entry p)))
			(setf strange (nconc strange (person-name entry)))
		)
	)
	strange
)
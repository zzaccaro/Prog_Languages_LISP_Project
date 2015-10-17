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
	(setf path "./input.txt")
	(readfile path)
)

(defun readfile (string)
    (with-open-file (infile string :direction :input)
        (do ((line (read-line infile nil 'eof) (read-line infile nil 'eof))) 
            ((eql line 'eof) 'done)

             (setf inputList (read-from-string line))
             (setf arg1 (first inputList))
             (setf arg2 (second inputList))
             (setf arg3 (third inputList))
             (setf arg4 (fourth inputList))

             (cond 
             	((eq 'E arg1) 
             		(if (eq nil arg4) 
             			(E1 arg2 arg3) 
             			(E2 arg2 arg3 arg4)
           			)
             	)
             	((eq 'R arg1) 
             		(progn 
             			(format t "~a~%" line) 
             			(print (R arg2 arg3)) 
             			(format t "~%")
             		)
             	)
             	((eq 'W arg1) 
             		(progn 
             			(format t "~a~%" line) 
             			(setf wPeopleList (W arg2 arg3)) 
             			(loop for x in wPeopleList do 
             				(print x)
             			) 
             			(format t "~%")
             		)
             	)
             	((eq 'X arg1) 
             		(progn 
             			(format t "~a~%" line) 
             			(print (X arg2 arg3 arg4)) 
             			(format t "~%")
             		)
             	)
             )
        )
    )
)

;; E query (first version)
(defun E1 (name1 name2)
	(checkOrAddToGraph name1 name1 name1)
	(checkOrAddToGraph name2 name2 name2)

	(add-spouse (gethash name1 familytree) name2)
	(add-spouse (gethash name2 familytree) name1)
)

;; E query (second version)
(defun E2 (name1 name2 name3)
	(checkOrAddToGraph name1 name1 name1)
	(checkOrAddToGraph name2 name2 name2)
	(checkOrAddToGraph name3 name1 name2)

	(add-spouse (gethash name1 familytree) name2)
	(add-spouse (gethash name2 familytree) name1)
)

(defun checkOrAddToGraph (nodeName par1 par2)
	(cond
		((eq (gethash nodeName familytree) nil) (setf (gethash nodeName familytree) (create-person nodeName (list par1 par2))))
		((isAdamAndEve nodeName) (setf (person-parents (gethash nodeName familytree)) (list par1 par2)))
	)
	(if (not (equalp par1 par2)) (progn (add-children (gethash par1 familytree) nodeName) (add-children (gethash par2 familytree) nodeName)))
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

(defun getCousins (p cuzNum remNum)
;"Gets a list of all of the First Cousins of person"
;"Gets parents, then parents siblings, then parent's sibling's kids"
;"CALLED WITH: (getCousinsXY '(person) 'number 'number)"
	(setf pList1 p)

	;get shared grandparents
	(dotimes (num cuzNum)
		(setf pList2 nil)
		(loop for x in pList1 do(
			setf pList2 (remove-duplicates(nconc pList2 (person-parents x)))))
		(setf pList1 pList2)
		)

	;get siblings of grandparents
	(setf pList2 nil)
	(loop for x in pList1 do(
		setf pList2 (remove-duplicates (nconc pList2 (getSiblings x)))))
	(setf pList1 pList2)

	;get children on cousin level
	(dotimes (num (+ cuzNum remNum))
		(setf pList2 nil)
		(loop for x in pList1 do(
			setf pList2 (remove-duplicates (nconc pList2 (person-children x)))))
		(setf pList1 pList2)
		)

	(setf pList1 (remove-duplicates (sort pList1 #'string-lessp)))
)

;; boolean for cousin
(defun isCousin (p1 p2 cuzNum remNum)
	 (member p1 (getCousins (list p2) cuzNum remNum))
)

;; boolean for relative
(defun isRelative (p1 p2)
	(setf p1rels (getAncestors p1))
	(setf p2rels (getAncestors p2))

	(loop for x in p1rels do 
		(loop for y in p2rels do 
			(if (equalp x y) (return-from isRelative t))
		)
	)
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

	(if (eq 'Cons (type-of relation))
		(progn 
			(setf answer (if (isCousin name1 name2 (second relation) (third relation)) "Yes" "No"))
			(return-from X answer)
		)
	)

	(cond 
		((equalp relation 'spouse) (setf answer (if (isSpouse p1 p2) "Yes" "No")))
		((equalp relation 'parent) (setf answer (if (isParent p1 p2) "Yes" "No")))
		((equalp relation 'sibling) (setf answer (if (isSibling p1 p2) "Yes" "No")))
		((equalp relation 'ancestor) (setf answer (if (isAncestor p1 p2) "Yes" "No")))
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

	;cousin case
	(if (eq 'Cons (type-of relation))
		(progn 
			(setf wPeople (nconc wPeople (getCousins person (second relation) (third relation))))
			(return-from W wPeople)
		)
	)

	(cond
		((equalp relation 'spouse) (setf wPeople (nconc wPeople (person-spouse person))))
		((equalp relation 'parent) (if (isAdamAndEve name) (setf wPeople (nconc wPeople (list name))) (setf wPeople (nconc wPeople (person-parents person)))))
		((equalp relation 'sibling) (setf wPeople (nconc wPeople (getSiblings person))))
		((equalp relation 'ancestor) (setf wPeople (nconc wPeople (getAncestors person))))
		((equalp relation 'relative) (setf wPeople (nconc wPeople (getRelatives person))))
		((equalp relation 'unrelated) (setf wPeople (nconc wPeople (getStrangers person))))
	)

	(setf wPeople (sort wPeople #'string<))
	wPeople
)

;; collects all people who are siblings of a person
(defun getSiblings (p)
	(setf siblings ())

	(loop for entry being the hash-keys of familytree do 
		(if (isSibling p (gethash entry familytree))
			(setf siblings (nconc siblings (list entry)))
		)
	)
	siblings
)

;; collects all people who are ancestors of a person
(defun getAncestors (p)
	(setf ancestrs ())
	(loop for entry being the hash-keys of familytree do 
		(if (checkParents (gethash entry familytree) p)
			(setf ancestrs (nconc ancestrs (list entry)))
		)
	)
	;cond for if no ancestors
	(if (eq ancestrs nil)
		(setf ancestrs (list (person-name p)))
	)
	;return ancestors
	ancestrs
)

;; collects all people who are relatives of a person
(defun getRelatives (p)
	(setf rels ())
	(loop for entry being the hash-keys of familytree do 
		(if (isRelative (gethash entry familytree) p)
			(setf rels (nconc rels (list entry)))
		)
	)
	rels
)

;; collects all people who are not related to a person
(defun getStrangers (p)
	(setf strange ())
	(loop for entry being the hash-keys of familytree do 
		(if (and (not (isRelative entry p)) (not (isSpouse entry p)))
			(setf strange (nconc strange (list entry)))
		)
	)
	strange
)
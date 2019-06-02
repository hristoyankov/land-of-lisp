(defparameter *nodes* '((living-room (you are in the living room.
				      a wizard is snoring in the couch.))
			(garden (you are in a beatiful garden.
				 there is a well in front of you.))
			(attic (you are in the attic.
				there is a giant welding torch in the corner.))))

(defun describe-location
    (location nodes)
  (cadr (assoc location nodes)))

(defparameter *edges* '((living-room
			 (garden west door)
			 (attic upstairs ladder))
			(garden (living-room east door))
			(attic (living-room downstairs ladder))))

(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

(defparameter *objects* '(whiskey bucket frog chain))

(defparameter *object-locations* '((whiskey living-room)
				   (bucket living-room)
				   (chain garden)
				   (frog garden)))

(defun objects-at (location objects object-locations)
  (labels ((at-loc-p (obj)
	     (eq location (cadr (assoc obj object-locations)))))
    (remove-if-not #'at-loc-p objects)))

(defun describe-objects (location objects object-locations)
  (labels ((describe-object (obj)
	     `(you see ,obj on the floor.)))
    (apply #'append (mapcar #'describe-object (objects-at location objects object-locations)))))

(defparameter *location* 'living-room)

(defun look ()
  (append (describe-location *location* *nodes*)
	  (describe-paths *location* *edges*)
	  (describe-objects *location* *objects* *object-locations*)))

(defun walk (direction)
  (let ((next (find direction
		    (cdr (assoc *location* *edges*))
		    :key #'cadr)))
    (if next
	(progn (setf *location* (car next))
	       (look))
	'(you cannot go that way))))

(defun pickup (object)
  (cond ((member object
		 (objects-at *location* *objects* *object-locations*))
	 (push (list object 'body) *object-locations*)
	 `(you now carry ,object))
	(t '(you cannot get that.))))

(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))
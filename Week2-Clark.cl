International Allegro CL Free Express Edition
9.0 [Mac OS X (Intel)] (Sep 7, 2012 15:28)
Copyright (C) 1985-2012, Franz Inc., Oakland, CA, USA.  All Rights Reserved.

This development copy of Allegro CL is licensed to:
   Allegro CL 9.0 Express user

CG version 9.0 / IDE version 9.0
Loaded options from /Users/apoh/.allegro-prefs-9-0-express.cl.

;; Optimization settings: safety 1, space 1, speed 1, debug 2.
;; For a complete description of all compiler switches given
;; the current optimization settings evaluate
;; (EXPLAIN-COMPILER-SETTINGS).

[changing package from "COMMON-LISP-USER" to "COMMON-GRAPHICS-USER"]
CG-USER(1): (defun hello () (write-string "Hello, Everyone!"))
HELLO
CG-USER(2): (hello)
Hello, Everyone!
"Hello, Everyone!"
CG-USER(3): (defun goodbye() (write-string ?Goodbye?))
GOODBYE
CG-USER(4): (goodbye)
Error: Attempt to take the value of the unbound variable `?GOODBYE?'.
[condition type: UNBOUND-VARIABLE]
CG-USER(5): (defun goodbye () (write-string ?Goodbye?))
GOODBYE
CG-USER(6): (goodbye)
Error: Attempt to take the value of the unbound variable `?GOODBYE?'.
[condition type: UNBOUND-VARIABLE]
CG-USER(7): (defun goodbye () (write-string "Goodbye"))
GOODBYE
CG-USER(8): (goodbye)
Goodbye
"Goodbye"
CG-USER(9): (defun middle-name (name) (second name))
MIDDLE-NAME
CG-USER(10): (middle-name '(Mary Jane Doe))
JANE
CG-USER(11): (defun second-of-second (name) (second (second name)))
SECOND-OF-SECOND
CG-USER(12): (second-of-second '((a b c) (1 x) (e f)))
X
CG-USER(13): (defun repeater (x)
             (loop repeat x do (format t "AI~C~%" #\return)))

REPEATER
CG-USER(14): (repeater 4)
AI

AI

AI

AI

NIL
CG-USER(15): (defun stuff ()
  (loop repeat 4
        sum (progn 
              (format t "Enter a number: ")
              (parse-integer (read-line)))))

STUFF
CG-USER(16): (defun adder ()
  (loop repeat 4
        sum (progn 
              (format t "Enter a number: ")
              (parse-integer (read-line)))))

ADDER
CG-USER(17): (adder)
Enter a number: 1

Enter a number: 2

Enter a number: 3

Enter a number: 4

10
NIL

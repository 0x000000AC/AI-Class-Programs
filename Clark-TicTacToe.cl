;****************************************************************************
; Park University
; CS305 - Introduction to Artificial Intelligence
; Aaron P. Clark
; 5 October 2014
;
; A common-lisp tic-tac-toe game.
;
;****************************************************************************

;----------------------------------------------------------------------------
; Environment setup
;
; This section will be the basis of the user gameplay display (the classic
; grid view that looks like an octothorpe #).   To facilitate gameplay, the
; letters X and O will represented by numeric values that will aid in
; updating certain portions of the playing fields and the ai in
; assessing spots where you are it will win so that it can act.
; Each zero represents a position left-to-right top-to-bottom on the table
;----------------------------------------------------------------------------


; Global variables.  10 Represents X and 1 Represents O.  The helper function
; convertToSymbol allows the user entering a value for the table grid to display
; their content on the board as an X or O respectively.
(setf *ai* 1)
(setf *player* 10)

; Global variables which represents winning combinations. 
; this variable is called by the helper function computeTrifecta
; which looks at the state of the table at that snapshot in time
; as well as the heart of the ai-decision functions as a basis for
; blocking the player or recognizing a win
(setf *winningCombo*
  '((1 2 3) (4 5 6) (7 8 9) ; Horizontal win
    (1 4 7) (2 5 8) (3 6 9) ; Vertical win
    (1 5 9) (3 5 7)))       ; Diagonal win

; The basis of the table where player markers go.
; Values are initialized at 0 for a blank space, and a 1 or 10 is 
; placed at each spot depending on which player entered a value and where.
(defun createTable ()
  (list 'table 0 0 0 0 0 0 0 0 0))


; convertToSymbol converts a zero, one, or ten to a space, an O, or an X, respectively. 
; It is called by printRow, which prints out one row of the board. 
; printRow is in turn called by PRINT-BOARD.
(defun convertToSymbol (num)
  (cond ((equal num 1) "O")
        ((equal num 10) "X")
        (t " ")))

(defun printRow (x y z)
  (format t "~& ~A | ~A | ~A"
    (convertToSymbol x)
    (convertToSymbol y)
    (convertToSymbol z)))

(defun printTable (table)
  (format t "~%")
  (printRow
   (nth 1 table) (nth 2 table) (nth 3 table))
  (format t "~& -----------")
  (printRow
   (nth 4 table) (nth 5 table) (nth 6 table))
  (format t "~& -----------")
  (printRow
   (nth 7 table) (nth 8 table) (nth 9 table))
  (format t "~%~%"))


;----------------------------------------------------------------------------
; Player and AI Actions
;
; The heart of gameplay.  when you take a turn you are updating a position
; on the table with your mark.  Helper functions here add the values of the
; rows in an attempt to find winning combinations. sumRowValues adds rows
; that will be evaluated by computeTrifecta to find if a winning trinity
; of values is found.  If player O gets three in a row, the sum will be 3
; if the X player gets three in a row, the sum will be 30. The 
; isWinnerPredicate checks for that condition and is a conditional used by AI
; and player moves to stop play.
;----------------------------------------------------------------------------

(defun takeTurn (player pos table)
  (setf (nth pos table) player)
  table)

(defun sumRowValues (table triplet)
  (+ (nth (first triplet) table)
     (nth (second triplet) table)
     (nth (third triplet) table)))

(defun computeTrifecta (table)
  (mapcar #'(lambda (triplet)
              (sumRowValues table triplet))
    *winningCombo*))

(defun isWinnerPredicate (table)
  (let ((sums (computeTrifecta table)))
    (or (member (* 3 *ai*) sums)
        (member (* 3 *player*) sums))))



; Function for you, the player, asks you to type in a move.  If that
; move is between 1 and 9, utilizes isLegalMove function to check.  If invalid,
; recursively calls itself.  If valid, turns-over to aiMove
; and calls aiMove.  Also uses fullTablePredicate to see if there are conditions
; for ending the game

(defun playerMove (table)
  (let* ((pos (isLegalMove table))
         (newTable (takeTurn
                     *player*
                     pos
                     table)))
    (printTable newTable)
    (cond ((isWinnerPredicate newTable)
           (format t "~&The Player wins the game!"))
          ((fullTablePredicate newTable)
           (format t "~&Cats.  You tied."))
          (t (aiMove newTable)))))

(defun isLegalMove (table)
  (format t "~&Please enter a value 1-9: ")
  (let ((pos (read)))
    (cond ((not (and (integerp pos)
                     (<= 1 pos 9)))
           (format t "~&You have entered an invalid value.  Please enter 1-9.")
           (isLegalMove table))
          ((not (zerop (nth pos table)))
           (format t
               "~&You cannot place a marker there, it is occupied")
           (isLegalMove table))
          (t pos))))

(defun fullTablePredicate (table)
  (not (member 0 table)))

; The aiMove function is similar to the playerMove function.
; Now, however, you the computer has to assess the board to make
; a move.  It does this either randomly or 
; via a strategy that is derived from the conditions of the board
; at the time.
; This function returns a list of two elements.  The first
; element is th position in which to place an X.  The second
; element is a string explaining the strategy behind the move.

(defun aiMove (table)
  (let* ((chooseMove (decideMove table))
         (pos (first chooseMove))
         (strategy (second chooseMove))
         (newTable (takeTurn
                     *ai* pos table)))
    (format t "~&AI Selection: ~S" pos)
    (printTable newTable)
    (cond ((isWinnerPredicate newTable)
           (format t "~&AI is the winner."))
          ((fullTablePredicate newTable)
           (format t "~&Cats.  You tied."))
          (t (playerMove newTable)))))

; Decisions the aiMove can make are based on groupings of two.
; That is, if there is a group of two of it's symbols in play,
; complete the trifecta.  If the player is about to complete three,
; block their play. 
; chooseRandom picks a random number from 1 to 9, if empty, it 
; plays that number.  Otherwise, it calls itself recursively
; for more tries.
(defun decideMove (table) 
  (or (completeThree table)
      (stopHumanCompleteThree table)
      (chooseRandomly table)))

(defun chooseRandomly (table)
  (list (pickRandomEmpty table)
        "random move"))

(defun pickRandomEmpty (table)
  (let ((pos (+ 1 (random 9))))
    (if (zerop (nth pos table))
        pos
      (pickRandomEmpty table))))

(defun completeThree (table)
  (let ((pos (finishThreeOrBlockThree table
                           (* 2 *ai*))))
    (and pos (list pos "make three in a row"))))

(defun stopHumanCompleteThree (table)
  (let ((pos (finishThreeOrBlockThree table
                           (* 2 *player*))))
    (and pos (list pos "block opponent"))))

(defun finishThreeOrBlockThree (table targetSum)
  (let ((triplet (find-if
                  #'(lambda (trip)
                      (equal (sumRowValues table
                                          trip)
                             targetSum))
                  *winningCombo*)))
    (when triplet
      (findEmpty table triplet))))

(defun findEmpty (table squares)
  (find-if #'(lambda (pos)
               (zerop (nth pos table)))
           squares))



; The "main function" if you will. Allows user to begin turn.

(defun newGame ()
	(playerMove (createTable)))
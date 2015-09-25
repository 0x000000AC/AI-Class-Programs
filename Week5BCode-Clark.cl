; This function returns a random element of the list choices
(defun random-elt (choices)
        "Choose an element from a list at random."
	  ;; elt returns the (n + 1)th element of the list choices 
  ;; random returns a random integer no large than the number of
  ;;   elements in the list choices
        (elt choices (random (length choices))))
	
; This function returns a random element of the given set and returns 
; it in a list
(defun one-of (set)
         "Pick one element of set, and make a list of it."
         (list (random-elt set)))

; Define a sentence as a noun-phrase + verb phrase
(defun sentence ()  (append (noun-phrase) (verb-phrase)))

; Define a noun phrase as an article + noun
(defun noun-phrase () (append (Article) (Adjective) (Noun)))

; Define a verb phrase as a verb + a noun phrase
(defun verb-phrase () (append (Adverb) (Verb) (Preposition) (noun-phrase)))

; This function returns a randomly selected article
(defun Article () (one-of '(the a)))

; This function returns a randomly selected noun
(defun Noun () (one-of '(dog cat mouse fish)))

; This function returns a randomly selected verb
(defun Verb () (one-of '(ran yelped perused smelled)))

(defun Adjective () (one-of '(morose despondant cheerful merry)))
(defun Preposition () (one-of '(to at beside under)))
(defun Adverb () (one-of '(accidentally hurriedly loudly forcefully)))
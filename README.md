# cl-read-writer-lock

Read writer lock implementation from:
https://en.wikipedia.org/wiki/Reader-writer_lock#Using_a_condition_variable_and_a_mutex

This is write preferring.

```lisp
(in-package #:rw-lock)

(defvar *lock* (make-instance 'reader-writer-lock))

(defparameter *n* 0)

(defun test ()
  (let ((lamb (lambda ()
                (dotimes (i 1000000)
                  (incf *n*)))))
    (bt2:make-thread lamb)
    (bt2:make-thread lamb)))

;;;143075 not right

(defun test2 ()
  (let ((lamb (lambda ()
                (dotimes (i 1000000)
                  (write-with-rw-lock (*lock*)
                    (incf *n*))))))
    (bt2:make-thread lamb)
    (bt2:make-thread lamb)))

;;2000000 perfect

```

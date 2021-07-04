(defpackage #:cl-read-writer-lock
  (:use #:cl)
  (:nicknames #:rw-lock)
  (:export #:reader-writer-lock
           #:write-with-rw-lock
           #:read-with-rw-lock))

(asdf:defsystem #:cl-read-writer-lock
  :description "read biased read write locking macros"
  :author "k1d77a"
  :license  "MIT"
  :version "1.0.0"
  :serial t
  :depends-on (#:bordeaux-threads)
  :components ((:file "package")
               (:file "rw")
               (:file "example")))


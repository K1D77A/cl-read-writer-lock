(in-package #:cl-read-writer-lock)
;;;;read preferring read writer lock

(defstruct (read-writer)
  (counter-b 0 :type fixnum)
  (b-protector-r (bt:make-lock "b-protector") :type bt:lock)
  (global-writers (bt:make-lock "global-writers") :type bt:lock))

(defmacro write-with-read-writer ((lock) &body body)
  (alexandria:with-gensyms (counter b-protector-r global-writers)
    `(let ((,counter (read-writer-counter-b ,lock))
           (,b-protector-r (read-writer-b-protector-r ,lock))
           (,global-writers (read-writer-global-writers ,lock)))
       (bt:with-lock-held (,global-writers)
         (locally ,@body)))))

(defmacro read-with-read-writer ((lock) &body body)
  (alexandria:with-gensyms (counter b-protector-r global-writers)
    `(let ((,counter (read-writer-counter-b ,lock))
           (,b-protector-r (read-writer-b-protector-r ,lock))
           (,global-writers (read-writer-global-writers ,lock)))
       (bt:with-lock-held (,b-protector-r)
         (incf ,counter)
         (when (= ,counter 1)
           (bt2:lock-native-lock ,global-writers)))
       (unwind-protect 
            (locally ,@body)
         (bt:with-lock-held (,b-protector-r)
           (decf ,counter)
           (when (zerop ,counter)
             (bt:release-lock ,b-protector-r)))))))








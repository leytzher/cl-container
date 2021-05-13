(in-package :server)

;; create variable to store acceptor
(defvar *acceptor* nil)

;; start server
(defun start-server ()
  (stop-server)
  (hunchentoot:start (setf *acceptor*
               (make-instance 'easy-routes:easy-routes-acceptor
                              :port 5000))))
;;stop server
(defun stop-server ()
  (when *acceptor*
    (when (hunchentoot:started-p *acceptor*)
      (hunchentoot:stop *acceptor*))))

;; test route 
(easy-routes:defroute hello ("/hello") (name)
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "Hey~@[ ~A~]!" name))


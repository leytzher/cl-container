(asdf:defsystem "cl-api"
	:description "Simple api"
	:version "0.0.1"
	:depends-on ("hunchentoot" "easy-routes" "jonathan")
	:components ((:file "packages")
							 (:file "server" :depends-on ("packages"))
							 (:file "main" :depends-on ("server"))))

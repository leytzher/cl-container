## Common Lisp container running a simple REST API

This container is heavily inspired in https://github.com/cmatzenbach/conway-ff-api and https://github.com/rigetti/docker-lisp 

It is meant to be used as a starting point for more complex web services.

You can replace `cl-api.asd` with your own Lisp package(s).

<img src="lispLogo.svg" width=300 align=right>


### Build container:

`make cl-container`

### Run container:

`make run`

The server runs in `http://localhost:5000`.

It has an example end point `http://localhost:5000/hello` that you can use to test if all is okay.

### Live server in Swank

In Emacs:
<code>M-x slime-connect</code>
and use `localhost`  as host -- or your host IP address (if you are running remotely)-- and port `4005`

To debug/edit or make changes to the running image:
`(in-package :server)`
and hack away!


	

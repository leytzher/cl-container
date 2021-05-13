## Common Lisp container running a simple REST API

This container is heavily inspired in https://github.com/cmatzenbach/conway-ff-api and https://github.com/rigetti/docker-lisp 

It is meant to be used as a starting point for more complex web services.

<img src="lispLogo.svg" width=300 align=right>


### Build container:

`make cl-container`

### Run container:

`make run`

The server runs in `http://localhost:5000`.

It has an example end point `http://localhost:5000/hello/<your-name>` that you can use to test if all is okay.

### Live server in Swank

In Emacs:
<code>M-x slime-connect</code>
and use `localhost` as host and port `4005`
	

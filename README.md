## Common Lisp container running a simple REST API

This container is heavily inspired in https://github.com/cmatzenbach/conway-ff-api and https://github.com/rigetti/docker-lisp 

It is meant to be used as a starting point for more complex web services.

<img src="lispLogo" width=300 align=right>


### Build container:

`make cl-container`

### Run container:

`make run`

The server runs in port 5000.

### Live server in Swank

In Emacs:
<code>M-x slime-connect</code>
and use `localhost` as host and port `4005`
	

FROM phusion/baseimage:latest-amd64

# Get build variables 
ARG SBCL_VERSION
ARG SBCL_URL=https://ufpr.dl.sourceforge.net/project/sbcl/sbcl/${SBCL_VERSION}/sbcl-${SBCL_VERSION}-source.tar.bz2 
ARG QUICKLISP_VERSION
ARG QUICKLISP_URL=http://beta.quicklisp.org/dist/quicklisp/${QUICKLISP_VERSION}/distinfo.txt

# Install required packages
RUN apt update &&\
    apt-get install -y \
    build-essential \
    curl \
    wget \
    cmake \
    git \
    libblas-dev \
    libffi-dev \
    liblapack-dev \
    libz-dev \
    libzmq3-dev \
    libev-dev \
    rlwrap \
    time \
    sbcl && \
    apt-get clean

WORKDIR /src
# Installing SBCL
RUN wget ${SBCL_URL} && \
    tar jxvf sbcl-${SBCL_VERSION}-source.tar.bz2 && \
    rm /src/sbcl-${SBCL_VERSION}-source.tar.bz2 && \
    cd /src/sbcl-${SBCL_VERSION} && \
    ln -s /src/sbcl-${SBCL_VERSION} /src/sbcl && \
    sh make.sh --fancy --with-sb-dynamic-core --with-sb-linkable-runtime && \
    (cd src/runtime && make libsbcl.a) && \
    sh ./install.sh && \
    cd - 

# Install quicklisp
RUN curl -k -o /tmp/quicklisp.lisp 'https://beta.quicklisp.org/quicklisp.lisp' && \
    sbcl --noinform --non-interactive --load /tmp/quicklisp.lisp --eval \
        "(quicklisp-quickstart:install :dist-url \"${QUICKLISP_URL}\")" && \
    sbcl --noinform --non-interactive --load ~/quicklisp/setup.lisp --eval \
        '(ql-util:without-prompting (ql:add-to-init-file))' && \
    echo '#+quicklisp(push "/src" ql:*local-project-directories*)' >> ~/.sbclrc && \
    rm -rf /tmp/quicklisp.lisp 

RUN sbcl --noinform --non-interactive --eval '(ql:quickload :swank)' 

ADD . /src/custom-code
WORKDIR /src/custom-code

# make a symlink for our package (called cl-api in this case) to ~/quicklisp/local-projects
RUN ln -s /src/custom-code/cl-api/cl-api.asd ~/quicklisp/local-projects/cl-api.asd
RUN sbcl --noinform --non-interactive --eval '(ql:quickload :cl-api)'

# Make a dir for my source on the docker image
# RUN mkdir /src/
# Copy project directory to new directory on docker container
# COPY . /src/
#ADD ./conway-ff-api.asd /src/

# Create symlink to ~/quicklisp/local-projects for .asd file
# RUN ln -s /src/conway-ff-api/conway-ff-api.asd ~/quicklisp/local-projects/conway-ff-api.asd
# Let quicklisp do its thing
# RUN sbcl --noinform --non-interactive --eval '(ql:quickload :conway-ff-api)'

# Expose the port that hunchentoot is listening on
EXPOSE 5000
# Expose the port that swank is listening on
EXPOSE 4005

# Start SBCL and Swank 
CMD sleep 0.05; rlwrap sbcl --eval '(ql:quickload :swank)' \
  --eval "(require :swank)" \
	--eval "(setq swank::*loopback-interface* \"0.0.0.0\")" \
	--eval "(swank:create-server :port 4005 :style :spawn :dont-close t)" \
	--eval "(ql:quickload :cl-api)"

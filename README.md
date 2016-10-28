# Classlab 

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/classlab/classlab/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/classlab/classlab.svg?branch=master)](https://travis-ci.org/classlab/classlab) 
[![Coverage Status](https://coveralls.io/repos/github/classlab/classlab/badge.svg?branch=master)](https://coveralls.io/github/classlab/classlab?branch=master) 
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/classlab/classlab.svg)](https://beta.hexfaktor.org/github/classlab/classlab) 
[![Inline docs](http://inch-ci.org/github/classlab/classlab.svg?=123)](http://inch-ci.org/github/classlab/classlab)

## Installation

**Requirements**

* PostgreSQL


To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Set up the project the first time `mix setup`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Build and run the docker demo container

build: `docker build -t classlab/classlab-demo -f Dockerfile.demo .`

run: `docker run -p 8080:80 classlab/classlab-demo`

# Classlab [![Build Status](https://travis-ci.org/classlab/classlab.svg?branch=master)](https://travis-ci.org/classlab/classlab) [![Inline docs](http://inch-ci.org/github/classlab/classlab.svg?=123)](http://inch-ci.org/github/classlab/classlab) [![Coverage Status](https://coveralls.io/repos/github/classlab/classlab/badge.svg?branch=master)](https://coveralls.io/github/classlab/classlab?branch=master)

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

## Build and run demo container

build: `docker build -t symetics/classlab .`

run: `docker run --name classlab -d -p 8080:8080 symetics/classlab`

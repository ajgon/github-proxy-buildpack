#!/usr/bin/env bash

docker build -t github-proxy-buildpack/heroku-18 -f Dockerfile.heroku-18 .
docker build -t github-proxy-buildpack/heroku-20 -f Dockerfile.heroku-20 .

docker run --rm -t -v $(pwd)/bin:/tmp/bin github-proxy-buildpack/heroku-18 cp /tmp/nginx/sbin/nginx /tmp/bin/nginx-heroku-18
docker run --rm -t -v $(pwd)/bin:/tmp/bin github-proxy-buildpack/heroku-20 cp /tmp/nginx/sbin/nginx /tmp/bin/nginx-heroku-20

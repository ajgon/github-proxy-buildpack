#!/usr/bin/env bash

docker build -t github-proxy-buildpack/cedar-14 -f Dockerfile.cedar-14 .
docker build -t github-proxy-buildpack/heroku-16 -f Dockerfile.heroku-16 .
docker build -t github-proxy-buildpack/heroku-18 -f Dockerfile.heroku-18 .

docker run --rm -t -v $(pwd)/bin:/tmp/bin github-proxy-buildpack/cedar-14 cp /tmp/nginx/sbin/nginx /tmp/bin/nginx-cedar-14
docker run --rm -t -v $(pwd)/bin:/tmp/bin github-proxy-buildpack/heroku-16 cp /tmp/nginx/sbin/nginx /tmp/bin/nginx-heroku-16
docker run --rm -t -v $(pwd)/bin:/tmp/bin github-proxy-buildpack/heroku-18 cp /tmp/nginx/sbin/nginx /tmp/bin/nginx-heroku-18

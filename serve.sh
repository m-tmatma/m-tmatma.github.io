#!/bin/sh

docker run --rm --volume="$PWD:/srv/jekyll" -it --publish 0.0.0.0:4000:4000 jekyll/jekyll  jekyll serve


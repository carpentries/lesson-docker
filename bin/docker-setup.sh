#!/bin/bash

set -e

# This creates links to the gemfiles. The beauty behind this is that the
# residual gemfiles are not present in the directory anymore. 
if [ -e Gemfile ]; then
  echo "exists" > /dev/null
else
  cp /srv/gems/* /srv/site/
  chown jekyll:jekyll Gemfile
fi


exec "$@"

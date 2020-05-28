#!/bin/bash

set -e

# set a default password
export PASSWORD=${PASSWORD:=data4Carp}

# Initialize lesson if it doesn't exist already
if [ -e /home/rstudio/_config.yaml ]; then
  echo "yaml exists" > /dev/null
else
  cd /home/rstudio
  echo "Initializing lesson ..."
  python3 bin/lesson_initialize.py
fi

# record the inital state of the directory so that we can remove the detritus later
ls -1a /home/rstudio > /srv/in.txt

# This creates links to the gemfiles. The beauty behind this is that the
# residual gemfiles are not present in the directory anymore. 
if [ -e /home/rstudio/Gemfile ]; then
  echo "exists" > /dev/null
else
  cp -t /home/rstudio /srv/gems/Gemfile /srv/gems/Gemfile.lock
fi


exec "$@"

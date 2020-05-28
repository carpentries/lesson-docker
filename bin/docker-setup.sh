#!/bin/bash

set -e

# set a default password
export PASSWORD=${PASSWORD:=data4Carp}
export USER=${USER:=rstudio}

# Initialize lesson if it doesn't exist already
if [ -e /home/${USER}/_config.y*ml ]; then
  echo "yaml exists" > /dev/null
else
  cd /home/${USER}
  echo "Initializing lesson ..."
  python3 bin/lesson_initialize.py
fi

# record the inital state of the directory so that we can remove the detritus later
ls -1a /home/${USER} > /srv/in.txt

# This creates links to the gemfiles. The beauty behind this is that the
# residual gemfiles are not present in the directory anymore. 
if [ -e /home/${USER}/Gemfile ]; then
  echo "exists" > /dev/null
else
  cp -t /home/${USER} /srv/gems/Gemfile /srv/gems/Gemfile.lock
fi

# For the future: RStudio hosts binary packages for xenial and bionic, which 
# makes installs MUCH faster. When they add buster, we can use this pattern to
# take advantage of that service
#
# echo 'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' \
#   >> /home/${USER}/.Rprofile
# echo "options(repos = 'https://packagemanager.rstudio.com/all/__linux__/buster/latest')" \
#   >> /home/${USER}/.Rprofile

exec "$@"

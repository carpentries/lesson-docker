#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Here, we are creating the user jekyll so that jekyll knows it's safe to play
# with us. This *should* in theory have the same UID as
useradd --no-create-home jekyll

# This creates symbolic links from the src (which is where the lesson exists)
# to where the site will be built to avoid permissions issues. 
cp -rs /srv/src/* /srv/site/
# This creates links to the gemfiles. The beauty behind this is that the
# residual gemfiles are not present in the directory anymore. 
cp -rs /srv/gems/* /srv/site/

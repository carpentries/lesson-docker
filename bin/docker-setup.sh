#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

useradd --no-create-home jekyll
cp -rs /srv/src/* /srv/site/
cp -rs /srv/gems/* /srv/site/

#!/usr/bin/with-contenv bash

exec ${BUNDLE_BIN}/jekyll serve -s /home/rstudio -d /home/rstudio/_site --host 0.0.0.0 


#!/bin/bash

set -e

# This creates links to the gemfiles. The beauty behind this is that the
# residual gemfiles are not present in the directory anymore. 
if [ -e Gemfile ]; then
  echo "exists" > /dev/null
else
  cp -t /home/rstudio /srv/gems/Gemfile /srv/gems/Gemfile.lock
fi



echo "This is the alpha test of The Carpentries Lesson Template docker image."
echo "Please let us know if you find any issues."
echo ""
echo "-----------------------------------------------------------------------------------"
echo " Navigate your browser to http://localhost:8787 to open an RStudio sesssion."
echo " Navigate a separate browser tab to http://0.0.0.0:4000 to preview the site."
echo ""
echo " Username: rstudio"
echo " Password: ${PASSWORD}"
echo ""
echo "Once you are in RStudio in your browser, edit any of the files in _episodes_rmd/"
echo "and then run `make lesson-md` in the Terminal tab to render the lessons. The"
echo "website will update automatically"
echo "-----------------------------------------------------------------------------------"
echo ""
echo "When you are finished, close the browser windows and use <CTRL+C> to exit"
echo "this session. You should"
echo ""

exec "$@"

#!/usr/bin/with-contenv bash

echo ""
echo ""
echo "This is the alpha test of The Carpentries Lesson Template docker image."
echo "Please open an issue if you find any problems or have suggestions:"
echo "<https://github.com/carpentries/lesson-docker/issues/new>"
echo ""
echo "-----------------------------------------------------------------------------------"
echo ""
echo " ->> STEP 1 --- Preview Site: <http://0.0.0.0:4000>   <<-"
echo " ->> STEP 2 --- Open RStudio: <http://localhost:8787> <<-"
echo ""
echo " Username: rstudio"
echo " Password: ${PASSWORD}"
echo ""
echo "Once you are in RStudio in your browser, edit any of the files in \`_episodes_rmd/\`"
echo "and then run \`make lesson-md\` in the Terminal tab to render the lessons. The"
echo "website will update automatically"
echo "-----------------------------------------------------------------------------------"
echo ""
echo "When you are finished, close the browser windows and use <CTRL+C> to exit"
echo "this session."
echo ""

# Note: normally, we would be able to specify the input and output directory
# with flags from jekyll, BUT because of remote themes, we have to enter the
# directory with jekyll, which is not bad per se, just a bit more annoying.
exec /bin/bash -c "cd /home/rstudio && ${BUNDLE_BIN}/jekyll serve --host 0.0.0.0"


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

echo "This is the alpha test of The Carpentries Lesson Template docker image."
echo "Please let us know if you find any issues."
echo ""
echo "-----------------------------------------------------------------------------------"
echo "To render your RMarkdown documents into markdown, please use the following command:"
echo "    make lesson-md"
echo ""
echo "To preview your site, please use:"
echo "    jekyll serve --host 0.0.0.0"
echo "-----------------------------------------------------------------------------------"
echo ""
echo "You can edit your RMarkdown documents and re-render them using the commands"
echo "above. When you are finished, you can type 'exit' to exit this container."
echo ""

exec "$@"

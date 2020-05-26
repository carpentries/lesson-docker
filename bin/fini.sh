#!/usr/bin/with-contenv bash

bold=$(tput bold)
normal=$(tput sgr0)
# List all of the files that exist in the directory after rstudio made its mess
ls -1a /home/rstudio > /srv/out.txt

# calculate the diffs
DIFFS=( $(comm -13 /srv/in.txt /srv/out.txt) )

# remove everything
echo "Cleaning up..."
rm -fd /home/rstudio/kitematic
echo 
for f in ${DIFFS[@]}
do
  if [ $f != "episodes_" ]
  then
    echo "Removing $f"
    rm -rf /home/rstudio/$f
  fi
done

echo ""
echo "NOTE: If any folder or important file was removed by accident, you can"
echo "restore it by running"
echo ""
echo "    git checkout -- FILE_NAME"
echo ""
echo "replacing FILE_NAME with the name of the file or folder that was removed."
echo ""

# carpentries-docker-test

This creates a simple docker container that has Jekyll built on top of 
[rocker/verse] with Hadley Wickham's [{requirements}] doing the work of
scanning RMarkdown files for content. This is designed to work with current
iterations of the lessons.

Ideally this should reduce the pain of running the lessons by requiring only
one piece of software be installed: docker.

# Installing Docker

Instructions for installing Docker Desktop on Windows and MacOS are available
on the docker website: <https://www.docker.com/products/docker-desktop>

# Running the container

> Note: because of the R installation and publishing tools, this image ends up 
> being quite large (~3.5 GB).

To run this container, set your working directory to a lesson you maintain and
run the following command:

UNIX (MacOS and Linux):

```sh
docker run --rm -it \
  -v ${PWD}:/home/rstudio \
  -p 4000:4000 \
  -p 8787:8787 \
  -e PASSWORD=yourpasswordhere \
  -e USERID=$(id -u) \
  -e GROUPID=$(id -g) \
  zkamvar/carpentries-docker-test
```

Windows (n.b. this is untested)

```sh
docker run --rm -it \
  -v ${PWD}:/home/rstudio \
  -p 4000:4000 \
  -p 8787:8787 \
  -e PASSWORD=yourpasswordhere \
  zkamvar/carpentries-docker-test
```

Pros: no installation of jekyll, R, python, etc. required

Cons: the container currently has no memory of the installed R packages and must
rebuild these every time it is intialized. 




[rocker/verse]: https://www.rocker-project.org/
[{requirements}]: https://github.com/hadley/requirements

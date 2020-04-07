# carpentries-docker-test

This creates a simple docker container that has Jekyll built on top of 
[rocker/verse] with Hadley Wickham's [{requirements}] doing the work of
scanning RMarkdown files for content. This is designed to work with current
iterations of the lessons.

To run this container, set your working directory to a lesson you maintain and
run the following command:

UNIX (MacOS and Linux):

```sh
docker run --rm -it -v $(pwd):/srv/site -p 4000:40000 -u $(id -u):$(id -g)
zkamvar/carpentries-docker-test
```

Windows (n.b. this is untested)

```sh
docker run --rm -it -v=%cd%:/srv/site -p 4000:4000 zkamvar/carpentries-docker-test
```

Pros: no installation of jekyll, R, python, etc. required

Cons: the container currently has no memory of the installed R packages and must
rebuild these every time it is intialized. 




[rocker/verse]: https://www.rocker-project.org/
[{requirements}]: https://github.com/hadley/requirements

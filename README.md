# Docker container for lesson maintenance

This creates a docker container that has Jekyll built on top of 
[rocker/verse] with Hadley Wickham's [{requirements}] doing the work of
scanning RMarkdown files for content. This is designed to work with all 
Carpentries' lessons. 

The main goal of this project is to provide a single software requirement for
building and maintiaining lessons officially supported by the Carpentries.

Pros: no installation of jekyll, R, python, etc. required

Cons: the container currently has no memory of the installed R packages and must
rebuild these every time it is intialized. 

# Installing Docker

Instructions for installing Docker Desktop on Windows and MacOS are available
on the docker website: <https://www.docker.com/products/docker-desktop>

# Working on your lesson

To work on your lesson, you should be in the working directory of your lesson 
and have docker community edition running (you should see a little docker icon
in your taskbar). You will work on your lesson via RStudio Server that is hosted
locally in your browser. You will need to do the following steps:

1. Run the docker container (see "Running the container", below)
2. Open http://0.0.0.0:4000 to preview the site
3. Open http://localhost:8787 to enter RStudio Server
4. Edit any files in `_episodes_rmd` that you want to modify.
5. Run `make lesson-md` in the RStudio terminal tab. The site will update
   automatically (if you would like to force everything to build, 
   run `make -B lesson-md`)
6. To exit, hit ctrl+c

## Running the container

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
  -e USERID=$(id -u) \
  -e GROUPID=$(id -g) \
  carpentries/lesson-docker
```

Windows (n.b. this is untested)

```sh
docker run --rm -it \
  -v ${PWD}:/home/rstudio \
  -p 4000:4000 \
  -p 8787:8787 \
  carpentries/lesson-docker
```

When the Docker container is running you should see this in your terminal window:


<details>

<summary>First message from Docker container:</summary>

```sh
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] add: executing... 
Nothing additional to add
[cont-init.d] add: exited 0.
[cont-init.d] userconf: executing... 
deleting user rstudio
creating new rstudio with UID 1001
useradd: warning: the home directory already exists.
Not copying any file from skel directory into it.
mkdir: cannot create directory ‘/home/rstudio’: File exists
Modifying primary group rstudio
Primary group ID is now custom_group 1001
[cont-init.d] userconf: exited 0.
[cont-init.d] done.
[services.d] starting services


This is the alpha test of The Carpentries Lesson Template docker image.
Please open an issue if you find any problems or have suggestions:
<https://github.com/carpentries/lesson-docker/issues/new>

-----------------------------------------------------------------------------------

 ->> Open RStudio: <http://localhost:8787> <<-
 ->> Preview Site:   <http://0.0.0.0:4000> <<-

 Username: rstudio
 Password: data4Carp

Once you are in RStudio in your browser, edit any of the files in `_episodes_rmd/`
and then run `make lesson-md` in the Terminal tab to render the lessons. The
website will update automatically
-----------------------------------------------------------------------------------

When you are finished, close the browser windows and use <CTRL+C> to exit
this session.

[services.d] done.
Configuration file: /home/rstudio/_config.yml
            Source: /home/rstudio
       Destination: /home/rstudio/_site
 Incremental build: disabled. Enable with --incremental
      Generating... 
                    done in 0.844 seconds.
 Auto-regeneration: enabled for '/home/rstudio'
    Server address: http://0.0.0.0:4000
  Server running... press ctrl-c to stop.
```

</details>

## Cleaning up

At the moment, there are two folders left over from RStudio that will either be
empty or will need to be removed.

```
.bash_history
kitematic/
```

You should not commit these files to your repository. Instead, remove them
manually for now. Once these are our of the way, you may commit and push your
changes.

[rocker/verse]: https://www.rocker-project.org/
[{requirements}]: https://github.com/hadley/requirements

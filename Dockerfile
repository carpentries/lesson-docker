FROM rocker/verse:3.6.3

ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV JEKYLL_VERSION=3.8.5
ENV JEKYLL_BIN=/usr/jekyll/bin
ENV PATH="${JEKYLL_BIN}:${BUNDLE_BIN}:$PATH"

WORKDIR /srv/gems
COPY ./Gemfile /srv/gems/Gemfile

# Install ruby and python pip
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  ruby \
  ruby-dev \
  build-essential \
  libxml2-dev \
  python3-pip \
  python3-setuptools \
  && echo "gem: --no-ri --no-rdoc" > ~/.gemrc 

# Install PyYAML for checking validity of episodes
RUN pip3 install wheel \
  && pip3 install PyYAML

# Setup and install jekyll. 
RUN export PATH=$(ruby -e 'puts Gem.user_dir')"/bin":$PATH \
  && yes | gem install --force bundler \
  && bundle install \
  && bundle update

# Set the working directory and add the setup script
WORKDIR /srv/site
COPY ./bin/docker-setup.sh /usr/local/bin/docker-setup.sh

# Install requirements package and allow users to install
# R packages when building the lessons
RUN R -e "devtools::install_github('hadley/requirements')" 

# Start and finish scripts for jekyll server
COPY bin/start.sh /etc/services.d/jekyll/run
COPY bin/fini.sh /etc/services.d/jekyll/finish

# This entrypoint is a bit of a hack at the moment because I keep getting an
# error if I put more than one lin in the run script above. This copies the
# Gemfiles from /srv/gems to /rstudio/home
ENTRYPOINT ["/usr/local/bin/docker-setup.sh"]
CMD ["/init"]

EXPOSE 35729
EXPOSE 4000

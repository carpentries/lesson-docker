FROM rocker/verse:latest

# --
# EnvVars
# Ruby
# --

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
  && bundle update \
  && useradd jekyll 

# Set the working directory and add the setup script
WORKDIR /srv/site
COPY ./bin/docker-setup.sh /usr/local/bin/docker-setup.sh

# Install requirements package and allow users to install
# R packages when building the lessons
RUN R -e "devtools::install_github('hadley/requirements')" 
RUN mkdir -p /home/jekyll/RLibrary \
 && echo "R_LIBS=~/RLibrary" > /home/jekyll/.Renviron \
 && chown -R jekyll:jekyll /home/jekyll

ENV R_ENVIRON_USER=~/.Renviron

ENTRYPOINT ["/usr/local/bin/docker-setup.sh"]
CMD ["bash"]

EXPOSE 35729
EXPOSE 4000

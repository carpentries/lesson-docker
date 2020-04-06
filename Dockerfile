# Explicitly set Jekyll version across all repos
ARG JEKYLL_VERSION=3.8.5
FROM rocker/verse:latest

# Set up jekyll
#
# Most of these are lifted directly from <https://github.com/envygeeks/jekyll-docker>

# --
# EnvVars
# Ruby
# --

ENV BUNDLE_HOME=/usr/local/bundle
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_BIN=/usr/gem/bin
ENV GEM_HOME=/usr/gem

# --
# EnvVars
# Image
# --
ENV JEKYLL_VAR_DIR=/var/jekyll
ENV JEKYLL_VERSION=3.8.5
ENV JEKYLL_DATA_DIR=/srv/site
ENV JEKYLL_BIN=/usr/jekyll/bin
ENV JEKYLL_ENV=development

# --
# EnvVars
# System
# --
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV PATH="${JEKYLL_BIN}:${BUNDLE_BIN}:$PATH"

WORKDIR /srv/gems
COPY ./Gemfile /srv/gems/Gemfile

# Install Jekyll and build the Gems
RUN apt-get update && apt-get install -y --no-install-recommends \
  ruby-full \
  build-essential \
  zlib1g-dev \
  && mkdir -p $JEKYLL_VAR_DIR \
  && mkdir -p $JEKYLL_DATA_DIR \
  && echo "gem: --no-ri --no-rdoc" > ~/.gemrc \
  && unset GEM_HOME \
  && unset GEM_BIN \
  && yes | gem update --system \
  && unset GEM_HOME \
  && unset GEM_BIN \
  && yes | gem install --force bundler \
  && gem install jekyll -v${JEKYLL_VERSION} -- --use-system-libraries \
  && bundle update \
  && bundle install 

WORKDIR /srv/site
COPY ./bin/docker-setup.sh /srv/site/bin/docker-setup.sh

RUN R -e "devtools::install_github('hadley/requirements')" 


ENTRYPOINT /bin/bash -c bin/docker-setup.sh && bash

EXPOSE 35729
EXPOSE 4000


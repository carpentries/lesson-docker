# Explicitly set Jekyll version across all repos
ARG JEKYLL_VERSION=3.8.5
FROM jekyll/jekyll:${JEKYLL_VERSION}
COPY ./Gemfile /srv/gems/Gemfile

WORKDIR /srv

RUN chown jekyll:jekyll gems \
  && cd gems \
  && bundle update \
  && bundle install

WORKDIR /srv/jekyll
CMD bash


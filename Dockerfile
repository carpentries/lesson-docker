# Explicitly set Jekyll version across all repos
ARG JEKYLL_VERSION=3.8.5
FROM jekyll/jekyll:${JEKYLL_VERSION}
COPY ./Gemfile /srv/gems/Gemfile

WORKDIR /srv

RUN chown jekyll:jekyll gems \
  && cd gems \
  && bundle update \
  && bundle install

# This is apparently how you jackknife one container into another and it's 
# WEIRD ಠ_ಠ
# https://github.com/moby/moby/issues/3378#issuecomment-411824851
COPY --from=rocker/verse:latest / /

# https://github.com/envygeeks/jekyll-docker/blob/master/repos/jekyll/copy/all/usr/jekyll/bin/entrypoint
ENV JEKYLL_UID=0
ENV JEKYLL_GID=0

RUN R -e "devtools::install_github('hadley/requirements')"
RUN mkdir /srv/site
COPY ./bin/docker-setup.sh /srv/site/bin/docker-setup.sh

WORKDIR /srv/site

ENTRYPOINT bin/docker-setup.sh &&

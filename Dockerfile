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

# N.B. This is not working at the moment because jekyll is giving me this error
# when I try to run jekyll as the jekyll user:
#
# $ /usr/jekyll/bin/jekyll --help
# /usr/jekyll/bin/jekyll: 5: /usr/jekyll/bin/jekyll: default-args: not found
#
# It's a bit weird because the scripts definitely exist there
# https://github.com/envygeeks/jekyll-docker/blob/master/repos/jekyll/copy/all/usr/jekyll/bin/entrypoint
# This will effectively make the current UID to be jekyll so that whenever R or
# jekyll runs something, it will be written as the current user ID instead of
# root or jekyll.
ENV JEKYLL_UID=0
ENV JEKYLL_GID=0
ENV BUNDLE_HOME=/usr/local/bundle
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_BIN=/usr/gem/bin
ENV GEM_HOME=/usr/gem
ENV JEKYLL_VAR_DIR=/var/jekyll
ENV JEKYLL_DATA_DIR=/srv/jekyll
ENV JEKYLL_BIN=/usr/jekyll/bin
ENV JEKYLL_ENV=development

RUN R -e "devtools::install_github('hadley/requirements')"
RUN mkdir /srv/site
COPY ./bin/docker-setup.sh /srv/site/bin/docker-setup.sh

WORKDIR /srv/site

ENTRYPOINT /bin/bash -c bin/docker-setup.sh && bash

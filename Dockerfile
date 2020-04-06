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

RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  ruby \
  ruby-dev \
  build-essential \
  libxml2-dev \
  && echo "gem: --no-ri --no-rdoc" > ~/.gemrc 

RUN export PATH=$(ruby -e 'puts Gem.user_dir')"/bin":$PATH \
  && yes | gem install --force bundler \
  && bundle install \
  && bundle update \
  && useradd --no-create-home jekyll \
  && mkdir -p /home/jekyll/Rlibrary


WORKDIR /srv/site
COPY ./bin/docker-setup.sh /usr/local/bin/docker-setup.sh

RUN R -e "devtools::install_github('hadley/requirements')" 
RUN echo "R_LIBS=~/RLibrary" > ~/.Renviron \
 && chown -R jekyll:jekyll /home/jekyll

ENTRYPOINT ["/usr/local/bin/docker-setup.sh"]
CMD ["make", "serve-in-container"]

EXPOSE 35729
EXPOSE 4000

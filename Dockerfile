FROM rocker/verse:4.0.3

ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV JEKYLL_BIN=/usr/jekyll/bin
ENV PATH="${JEKYLL_BIN}:${BUNDLE_BIN}:$PATH"

WORKDIR /srv/gems
COPY ./Gemfile /srv/gems/Gemfile

# Install python pip for validity checks
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  build-essential \
  libxml2-dev \
  python3-pip \
  python3-setuptools \
  jq \ 
  gnupg2 \
 && pip3 install wheel \
 && pip3 install PyYAML

# Get requirements from GitHub
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc \
 && wget -O ~/.ghvers.json "https://pages.github.com/versions.json" \
 && RBY=$(cat ~/.ghvers.json | jq --raw-output '.ruby') \
 && sed -i -e "s/RUBY_VERSION/${RBY}/" /srv/gems/Gemfile 

# Download the pinned Ruby version from GitHub
RUN RBY=$(cat ~/.ghvers.json | jq --raw-output '.ruby') \
 && RBY_MAJ=$(echo ${RBY} | sed -r -e "s/^([0-9]+[.][0-9]+)[.][0-9]+$/\1/") \
 && wget -O ~/RUBY.tar.gz "https://cache.ruby-lang.org/pub/ruby/${RBY_MAJ}/ruby-${RBY}.tar.gz"

# Install Ruby from source
RUN cd ~ \
 && RBY=$(cat ~/.ghvers.json | jq --raw-output '.ruby') \
 && tar -xzvf RUBY.tar.gz\
 && cd ruby-${RBY} \
 && ./configure \
 && make \
 && sudo make install


# Setup and install jekyll 
RUN yes | gem install --force bundler \
 && bundle install \
 && bundle update

# Install renv for checking dependencies
RUN R -q -e "remotes::install_version('renv', '0.10.0', repos = 'https://cloud.r-project.org')"

# Set the working directory and add the setup script
WORKDIR /srv/site
COPY ./bin/docker-setup.sh /usr/local/bin/docker-setup.sh

# Start and finish scripts for jekyll server
COPY bin/start.sh /etc/services.d/jekyll/run
COPY bin/fini.sh /etc/cont-finish.d/jekyll-finish

# This entrypoint is a bit of a hack at the moment because I keep getting an
# error if I put more than one lin in the run script above. This copies the
# Gemfiles from /srv/gems to /rstudio/home
ENTRYPOINT ["/usr/local/bin/docker-setup.sh"]
CMD ["/init"]

EXPOSE 35729
EXPOSE 4000

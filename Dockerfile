# Explicitly set Jekyll version across all repos
ENV JEKYLL_VERSION 3.8.5
FROM jekyll/jekyll:${JEKYLL_VERSION}

# Ensure that the Gemfile and Gemfile.lock have the right permissions
# see https://github.com/daattali/beautiful-jekyll/pull/503
COPY --chown=jekyll:jekyll Gemfile .
COPY --chown=jekyll:jekyll Gemfile.lock .

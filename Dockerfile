FROM ruby:2.6
MAINTAINER Kitsu, Inc.

RUN apt-get update -y && apt-get install -y libvips
# Install bundler
RUN gem install bundler -v '~> 2.1'

RUN mkdir -p /opt/kitsu/server
WORKDIR /opt/kitsu/server

# Preinstall gems in an earlier layer so we don't reinstall every time any file
# changes.
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=2 --without="development test"

# *NOW* we copy the codebase in
COPY . .

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80

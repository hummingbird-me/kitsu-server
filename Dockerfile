FROM ruby:2.6-alpine
MAINTAINER Kitsu, Inc.

RUN apk add --no-cache vips imagemagick git make gcc postgresql-client postgresql-dev build-base tzdata ffmpeg
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
# Precompile bootsnap cache
RUN bundle exec bootsnap precompile --gemfile app/ lib/

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80

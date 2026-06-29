FROM ruby:4.0.5-alpine
MAINTAINER Kitsu, Inc.

RUN apk add --no-cache vips imagemagick git make gcc postgresql-client postgresql-dev build-base tzdata ffmpeg curl bash yaml-dev cargo rust clang clang-dev llvm-dev
# Install bundler
RUN gem install bundler -v '~> 4.0'

RUN mkdir -p /opt/kitsu/server
WORKDIR /opt/kitsu/server

# Preinstall gems in an earlier layer so we don't reinstall every time any file
# changes.
COPY Gemfile Gemfile.lock ./
# Vendored path gems must be present for `bundle install` to resolve them.
COPY vendor/gems ./vendor/gems
RUN bundle config set --local without 'development test' \
  && bundle install --jobs=4 --retry=2

# *NOW* we copy the codebase in
COPY . .
# Precompile bootsnap cache
RUN bundle exec bootsnap precompile --gemfile app/ lib/

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80

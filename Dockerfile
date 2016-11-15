FROM rails:4.2
MAINTAINER Kitsu, Inc.

RUN mkdir -p /opt/kitsu/server

# Preinstall gems in an earlier layer so we don't reinstall every time any file
# changes.
COPY ./Gemfile /opt/kitsu/server/
COPY ./Gemfile.lock /opt/kitsu/server/
WORKDIR /opt/kitsu/server
RUN bundle install

# *NOW* we copy the codebase in
COPY . /opt/kitsu/server

ENV DATABASE_URL=postgresql://postgres:mysecretpassword@postgres/
ENV REDIS_URL=redis://redis/1
ENV ELASTICSEARCH_HOST=elasticsearch

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80

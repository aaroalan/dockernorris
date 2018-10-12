FROM ruby:2.3.7-slim-stretch AS build_image

RUN apt-get update
RUN apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev

RUN mkdir /app
WORKDIR /app

COPY . /app
RUN bundle install
RUN rm -fr /app/tmp/* && rm -fr /app/log/*

FROM ruby:2.3.7-slim-stretch AS app_image

RUN mkdir /app
WORKDIR /app

COPY --from=build_image /app /app
COPY --from=build_image /usr/local/bundle /usr/local/bundle

CMD bundle exec rails server -b 0.0.0.0

FROM ruby:2.5.0

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install --without assets development test

COPY . .

CMD bundle exec script/server

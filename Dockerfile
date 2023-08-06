FROM ruby:3.0.2

WORKDIR /usr/src/app

RUN mkdir -p tmp/pids

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

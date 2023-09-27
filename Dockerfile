FROM ruby:3.0.2

WORKDIR /usr/src/app

RUN mkdir -p tmp/pids

# Cronのインストール
RUN apt-get update && apt-get install -y cron

COPY Gemfile ./
COPY Gemfile.lock ./
COPY crontab /etc/cron.d/wakeup_notify_cron

RUN bundle install
RUN chmod 0644 /etc/cron.d/wakeup_notify_cron

COPY . .

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

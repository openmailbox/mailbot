FROM ruby:2.5

RUN git clone https://github.com/nevern02/mailbot.git

WORKDIR mailbot

RUN bundle install

COPY config/secrets.yml config/secrets.yml
COPY config/database.yml config/database.yml

CMD bin/mailbot start

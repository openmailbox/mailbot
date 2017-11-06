# Mailbot
A chat bot that works simultaneously in Twitch + Discord.

## Introduction
Mailbot started as a 50-line Ruby script live-coded on Twitch as an example of how to work with sockets. You can [watch the video here](https://www.youtube.com/watch?v=_FbRcZNdNjQ). Since then, it's slowly expanded to do random things when I can't find a good solution using other existing bots.

Mailbot is free to use under the terms of the license. If you don't want to spend the time setting up and deploying your own instance, you can ask me nicely to make the one I run available for your Twitch/Discord channel.

## Dependencies
* Ruby 2.3
* MySQL

## Setup
1. `git clone`
2. `bundle install`
3. `cp config/database.yml.example config/database.yml` and edit
4. `cp config/secrets.yml.example config/secrets.yml` and edit
5. Edit `config/settings.yml` and put in your bot account name
5. `rake db:create`
6. `rake db:migrate`
7. `bin/mailbot start`

**Note:** The bot will not work without valid API tokens and client IDs for both Twitch and Discord. Check the developer documentation for both services.

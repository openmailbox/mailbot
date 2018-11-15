[![Build Status](https://travis-ci.org/openmailbox/mailbot.svg?branch=master)](https://travis-ci.org/openmailbox/mailbot)

# Mailbot
A chat bot that works simultaneously in Twitch + Discord.

## Introduction
Mailbot started as a 20-line Ruby script live-coded on [Twitch](https://www.twitch.tv/open_mailbox) as an example of how to work with sockets. You can [watch the video here](https://www.youtube.com/watch?v=_FbRcZNdNjQ). Since then, it's slowly expanded to do random things when I can't find a good solution using other existing bots.

Mailbot is free to use under the terms of the license. If you don't want to spend the time setting up and deploying your own instance, there is a [hosted instance with a web UI](http://bot.open-mailbox.com). However, it currently only supports Discord connections.

## Dependencies
* Ruby 2.x (tested on 2.5.1)
* PostgreSQL (tested on 9.5)

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

## Adding Commands
Commands are POROs (plain old Ruby classes) that inherit from `Mailbot::Commands::Base` and live in `lib/mailbot/commands`. They just need to implement the `perform` method which must return a string that will be the result of using the command in chat. After creating a class, add a `require` statement to `lib/mailbot/commands.rb`.

## Adding Timers
Scheduled tasks consist of two parts. First, a subclass of `Mailbot::Models::Job` that implements the `perform` method. Second, a record in the database representing a particular instance of said job. Every five minutes, `Mailbot::Scheduler` will query for jobs and run any that are due. This Mailbot scheduler does not guarantee exact times, but only that a job **will not run any sooner than** the configured interval.

## Support
Find me in [Discord](http://bit.ly/mailboxdiscord).

## Contributing
Contributions are welcome. Make sure the tests pass (`bundle exec rake spec`).

## License
The source code is available under the terms of the [GPL v3 license](https://opensource.org/licenses/GPL-3.0).

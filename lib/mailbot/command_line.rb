require 'optparse'
require 'ostruct'

module Mailbot
  class CommandLine
    attr_reader :arguments, :options, :parser

    # @param [Array<String>] args The arguments passed in as ARGV
    def initialize(args)
      @arguments = args
      @options   = OpenStruct.new

      options.command   = args[0].to_s.downcase.to_sym
      options.discord   = true
      options.twitch    = true
      options.scheduler = true
    end

    def parse!
      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{$0.split('/').last} [COMMAND] [OPTIONS]"

        opts.separator ''
        opts.separator 'Commands:'
        opts.separator '      start: start bot'
        opts.separator '      stop: stop bot'
        opts.separator ''
        opts.separator 'Options:'

        opts.on('--without-discord', 'Start the bot without connecting to Discord.') do
          options.discord = false
        end

        opts.on('--without-twitch', 'Start the bot without connecting to Twitch chat.') do
          options.twitch = false
        end

        opts.on('--without-scheduler', 'Start the bot without running any scheduled jobs.') do
          options.scheduler = false
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end

      parser.parse!(arguments)
    end
  end
end

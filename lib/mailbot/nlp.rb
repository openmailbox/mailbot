require 'mailbot/nlp/parser'
require 'mailbot/nlp/actions/base'
require 'mailbot/nlp/actions/greeting'
require 'mailbot/nlp/actions/roll'
require 'mailbot/nlp/actions/time'

module Mailbot
  module NLP
    def self.actions
      Mailbot::NLP::Actions::Base.subclasses
    end
  end
end

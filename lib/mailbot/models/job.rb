# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  type        :string
#  frequency   :integer
#  last_run_at :datetime
#  details     :text
#
# Indexes
#
#  index_jobs_on_last_run_at  (last_run_at)
#

module Mailbot
  module Models
    class Job < ActiveRecord::Base
      serialize :details, JSON

      validates :frequency, presence: true, numericality: true

      after_initialize :initialize_details

      def perform
        raise NotImplementedError.new('Subclasses must implement #perform')
      end

      def ready?
        DateTime.now.to_i >= (last_run_at.to_i + frequency)
      end

      private

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      def initialize_details
        self.details ||= {}
      end
    end
  end
end

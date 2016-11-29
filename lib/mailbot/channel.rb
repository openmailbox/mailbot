module Mailbot
  class Channel
    attr_reader :logger, :running

    def initialize(logger = nil)
      @logger  = logger || Logger.new(STDOUT)
      @running = false
    end

    def listen
      logger.info "Initializing channel #{self.inspect}..."

      @running = true

      initialize_channel

      Thread.start do
        while (running) do
          run
        end
      end
    end

    def stop
      @running = false
    end

    private

    # Overridden in subclasses
    def initialize_channel
    end

    def run
      raise NotImplementedError.new('Subclasses must implement behavior.')
    end
  end
end

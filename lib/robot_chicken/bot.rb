require "telegram/bot"

module RobotChicken
  class Bot
    attr_reader :client

    def initialize
      @client = Telegram::Bot::Client.new(RobotChicken.api_token)

      RobotChicken.logger.info "Initializing #{bot_info.dig("result", "first_name")} [##{bot_info.dig("result", "id")}]"
    end

    def listen
      client.listen do |message|
        Message.reply(message) { |response| client.api.send(response[:action], response) }
      end
    rescue Faraday::ConnectionFailed => e
      RobotChicken.logger.warn "Faraday failing. Retrying. #{e}"
      retry if ENV["RUBY_ENV"] == "test"
    end

    private

    def bot_info
      @bot_info ||= client.api.get_me
    end
  end
end

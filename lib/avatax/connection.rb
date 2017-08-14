require 'faraday_middleware'

module AvaTax

  module Connection
    private

    def connection
      options = {
        :headers => {'Accept' => "application/json; charset=utf-8", 'User-Agent' => user_agent},
        :url => endpoint,
        :proxy => proxy,
      }.merge(connection_options)

      Faraday.new(options) do |faraday|
        faraday.use Faraday::Response::ParseJson
        faraday.basic_auth(username, password)

        if logger
          faraday.response :logger do |logger|
            logger.filter(/(Authorization\:\ \"Basic\ )(\w+)\=/, '\1[REMOVED]')
          end
        end

        faraday.adapter Faraday.default_adapter
      end
    end
  end
end

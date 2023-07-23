module Teller
  class Client
    URL = "https://api.teller.io".freeze

    def initialize(overrides={})
      config = Teller::Config.dup
      config.setup(overrides)
      
      client = Teller::API.new(config)
      entrypoint = client.get(URL)
      @target = Teller::Resource.new(entrypoint, client)
    end

    def method_missing(method, *args, &block)
      if @target.respond_to?(method)
        @target.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      @target.respond_to?(method)
    end
  end
end
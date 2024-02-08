module Teller
  class CollectionResource
    def initialize(url, collection, client)
      @url = url
      @collection = collection.map { |i| Teller::Resource.new(i, client) }
      @client = client
    end

    def get(id)
      url = @url + "/" + id
      Teller::Resource.new(@client.get(url), @client)
    end

    def delete
      @client.delete @url
      @collection = []
      true
    end

    def reload
      @collection = @client.get(@url).map { |i| Teller::Resource.new(i, @client) }
      self
    end

    def method_missing(method, *args, &block)
      if @collection.respond_to?(method)
        @collection.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      @collection.respond_to?(method) || super
    end

    def inspect
      @collection
    end
  end
end
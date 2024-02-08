require 'json'
require 'net/http'
require 'uri'
require 'base64'
require 'ostruct'

class Teller::Resource < OpenStruct
  def initialize(state, client)
    @client = client
    super(state)
  end

  def method_missing(method, *args, &block)    
    if @table[:links].key?(method.to_s)
      @table[method] ||= subresource(table[:links][method.to_s])
      @table[method]
    else
      super
    end
  end

  def delete
    @client.delete @table[:links]["self"]
    true
  end

  def reload
    initialize(@client.get(@table[:links]["self"]), @client)
    self
  end 

  def respond_to_missing?(method, include_private = false)
    @table[:links]&.key?(method.to_s) || super
  end

  private

  def subresource(link)
    state = @client.get(link)

    if state.is_a?(Array)
      Teller::CollectionResource.new(link, state, @client)
    else
      Teller::Resource.new(state, @client)
    end
  end
end

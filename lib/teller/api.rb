class Teller::API
  class Error < StandardError; end
  def initialize(config)
    @config = config
  end

  def delete(url)
    request(:delete, url)
  end

  def get(url)
    request(:get, url)
  end

  def post(url, body)
    request(:post, url, body)
  end

  def request(method, url, body=nil)

    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true 

    if @config.certificate && @config.private_key
      http.cert = @config.certificate
      http.key = @config.private_key
    end

    klass = Net::HTTP.const_get(method.to_s.capitalize)

    request = klass.new(uri.request_uri)

    if body
      request.body = body.to_json
      request.add_field("Content-Type", "application/json")
    end


    if @config.access_token
      request.add_field('Authorization', "Basic #{Base64.strict_encode64("#{@config.access_token}:")}")
    end

    response = http.request(request)

    case response
      when Net::HTTPNoContent
        return
    when Net::HTTPSuccess
      JSON.parse(response.body)
    when Net::HTTPClientError, Net::HTTPServerError
      error = JSON.parse(response.body) 
      raise Error, "#{error["error"]["code"]} - #{error["error"]["message"]}"
    end
  end
end
class Teller::HTTP
  def initialize(config)
    @config = config
  end

  def get(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true 

    if @config.certificate && @config.private_key
      http.cert = @config.certificate
      http.key = @config.private_key
    end

    request = Net::HTTP::Get.new(uri.request_uri)

    if @config.access_token
      request.add_field('Authorization', "Basic #{Base64.strict_encode64("#{@config.access_token}:")}")
    end

    response = http.request(request)
    
    JSON.parse(response.body)
  end
end
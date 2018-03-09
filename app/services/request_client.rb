class RequestClient
  include HTTParty
  
  open_timeout 2
  read_timeout 10

  def self.request(http_method, url, options)
    raise ArgumentError, "#{http_method} method not allowed" unless ['get', 'post'].include?(http_method)
    send(http_method, url, options)
  end
end

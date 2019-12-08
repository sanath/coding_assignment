require 'net/http'
require 'json'

class AdServiceClient
  BASE_URL = 'https://mockbin.org'
  private_constant :BASE_URL

  def get_ads
    path = 'bin/fcb30500-7b98-476f-810d-463a0b8fc3df'
    response = Net::HTTP.get(URI::join(BASE_URL, path))
    JSON.parse(response, symbolize_names: true)
  end
end
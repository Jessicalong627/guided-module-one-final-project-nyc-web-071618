
require 'rest-client'
require 'json'


class Api

  @@apikey = ""

  def self.apikey=(key)
    @@apikey = key
  end

  def self.apikey
    @@apikey
  end

  def self.get_event_by_zipcode(zipcode)
    content = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json',{params:{:zipcode => zipcode, :apikey => "GJnZhUjnM74QrszTtFEcCrluTU3RyBMl"}})
    data = JSON.parse(content)
    puts data["_embedded"].keys
    puts data["_embedded"]["events"][0]
  end
end

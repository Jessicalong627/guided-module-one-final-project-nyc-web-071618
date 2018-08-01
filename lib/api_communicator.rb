require 'rest-client'
require 'json'

require_relative '../config/key'
def get_data_by_zip_code(postalcode)
  get_data = RestClient.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&postalCode=#{postalcode}")
  data = JSON.parse(get_data)

  events = data["_embedded"]["events"]
  events.map do |event|
      "#{event["id"]} #{event["name"]} #{event["_embedded"]["venues"][0]["name"]}"
  end
end

def get_data_by_id(event_id)
  get_data = RestClient.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{API_KEY}&id=#{event_id}")
  data = JSON.parse(get_data)
  data["_embedded"]["events"][0]
end

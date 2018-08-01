
def login
  puts "Enter your name"
  username = gets.chomp
  user = User.find_by(name:username)
  if user == nil
    user = User.create(name:username)
    cur_user = user
  end
end

def welcome
  puts "Welcome, #{login}!"
  options
end

def options
  while true
    puts "Choose 1, 2, 3 or exit"
    puts "1. Search for an event near me."
    puts "2. Buy a ticket"
    puts "3. Show my orders"
    cmd = gets.chomp
    if cmd == "1"
      search_event_near_me

    elsif cmd == "2"
      buy_ticket

    elsif cmd == "3"
      show_orders

    elsif cmd == "exit"
      login

    else
      puts "Please choose 1, 2, 3, or exit"
    end
  end
end


def search_event_near_me
  puts "Enter your zip code"
  zipcode = gets.chomp
  puts get_data_by_zip_code(zipcode)
  #todo get data from api
end

def get_event_id
    puts "Enter an event id"
    event_id = gets.chomp
end

def buy_ticket
  event_id = get_event_id
  event_data = get_data_by_id(event_id) #calling api
  if event_data == nil
    puts "The event id is not available"
  else
    puts "Thank you for your purchase"
    event = Event.find_by(eid:event_id)
    if event == nil
        venue = event_data["_embedded"]["venues"][0]["name"]
        event_name =  event_data["name"]
        event = Event.create(name: event_name, venue: venue, eid: event_id)
    end
    Order.create(user_id:cur_user.id, event_id: event_id)
  end
  #search api to see if event_id matches
  #if it does puts "Thank you for your purchase"
  #if it doesnt puts im sorry
end

def show_orders
  puts "Here is your order"
  puts self.order
  #todo show all of the orders belongs to user

end

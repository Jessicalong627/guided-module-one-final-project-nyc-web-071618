@CUR_USER = nil

def login
  puts "Enter your name or exit".blue.underline
  username = gets.chomp
  if username == "exit"
    puts "See you later!"
    exit
  end
  user = User.find_by(name:username)
  if user == nil
    user = User.create(name:username)
    @CUR_USER = user
  else
    @CUR_USER = user
  end
  @CUR_USER.name
end

def welcome
  puts "Welcome, #{login}!"
  options
end

def options
  while true
    puts ""
    puts "Choose 1, 2, 3 or exit".green
    puts "1. Search for an event near me.".green
    puts "2. Buy a ticket".green
    puts "3. Show my orders".green
    puts ""
    cmd = gets.chomp
      puts ""
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
  array =  get_data_by_zip_code(zipcode)
  if array.size == 0
    puts "Please enter a valid zipcode".red
  else
    puts array
  end
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
    puts "The event id is not available".red
  else
    quantity = 0
    while true
      puts "How many tickets do you want? (Limit 5)"
      quantity = gets.chomp.to_i
      if quantity <= 0 || quantity > 5
        puts "The quantity is invalid. Enter a new quantity".red
      else
        break
      end
    end
    puts "Thank you for your purchase"
    event = Event.find_by(eid:event_id)
    if event == nil
        venue = event_data["_embedded"]["venues"][0]["name"]
        event_name =  event_data["name"]
        event = Event.create(name: event_name, venue: venue, eid: event_id)
    end
    Order.create(user_id:@CUR_USER.id, event_id: event.id,quantity:quantity)
  end
  #search api to see if event_id matches
  #if it does puts "Thank you for your purchase"
  #if it doesnt puts im sorry
end

def show_orders
  if @CUR_USER.orders == []
    puts "You don't have any orders.".red
  else
    puts "Here is your order"
    @CUR_USER.orders.each do |order|
      puts "Name:#{order.event.name} | Quantity:#{order.quantity} | Purchased date:#{order.created_at}"
    end
  end
  puts ""
  #todo show all of the orders belongs to user

end

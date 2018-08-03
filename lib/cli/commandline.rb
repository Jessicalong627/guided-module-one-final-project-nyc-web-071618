@CUR_USER = nil


def login
  puts " "
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
  a = Artii::Base.new
  puts "
  _______       __
//   ------.   / ._`_
|  //         ~--~    \\
| |             __    `.______________________^-----^
| |  I=|=======/--\\==========================| o o o |
\\ |  I=|=======\\__//=========================|_o_o_o_|
\\|                   /                       ~    ~
  \\       .---.    .
    -----'     ~~''

  ".red

  name = login
  puts a.asciify("Welcome ").blue
  puts a.asciify("   " + name).red


  options
end

def options
  while true
    puts ""
    puts "Choose 1, 2, 3 or exit".green
    puts "1. Search for an event near me.".green
    puts "2. Buy a ticket".green
    puts "3. Show my orders".green
    puts "4. Cancel my order".green
    puts ""
    cmd = gets.chomp
      puts ""
    if cmd == "1"
      search_event_near_me

    elsif cmd == "2"
      buy_ticket

    elsif cmd == "3"
      show_orders

    elsif cmd == "4"
      cancel_order

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
  puts " "
  arrays =  get_data_by_zip_code(zipcode)
  if arrays.size == 0
    puts "There are no events happening in this zip code".red
  else
    arrays.each{|array|
      puts "Event ID: ".green + array[0] + " | Name: ".green + array[1] + " | Venue: ".green + array[2] + " | Price: ".green + "$"+array[3].to_s
      puts " "
    }
  end
end

def get_event_id
    puts "Enter an event id"
    puts " "
    event_id = gets.chomp
end

def buy_ticket
  event_id = get_event_id
  event_data = get_data_by_id(event_id) #calling api
  if event_data == nil
    puts "This event id is not available".red
  else
    quantity = 0
    while true
      puts " "
      puts "How many tickets do you want? (Limit 5)"
      quantity = gets.chomp.to_i
      if quantity <= 0 || quantity > 5
        puts "This quantity is invalid. Enter a new quantity".red
      else
        break
      end
    end
    price = 40*quantity
    puts " "
    puts "Are you sure you want to purchase #{quantity} ticket(s) for $#{price}? (Y/N)"
    confirm = gets.chomp.upcase
    if confirm == "Y"
      puts " "
      puts "Thank you for your purchase!".blue

    else
      return
    end
    puts ""
    event = Event.find_by(eid:event_id)
    if event == nil
        venue = event_data["_embedded"]["venues"][0]["name"]
        event_name =  event_data["name"]
        event = Event.create(name: event_name, venue: venue, eid: event_id)
    end
    @CUR_USER.orders.create(user:@CUR_USER, event: event, quantity:quantity, price:price)
  end
end

def cancel_order
  show_orders
  puts "Enter order ID to cancel"
  order_id = gets.chomp.to_i
  order = Order.find(order_id)
  if order
    puts " "
    puts "Your order has been canceled.".underline
    @CUR_USER.orders.delete(order)
  else
    puts "You don't have this order"
  end
end


def show_orders
  if @CUR_USER.orders == []
    puts "You don't have any orders.".red
  else
    puts "Here is your order"
    @CUR_USER.orders.each do |order|
      puts "ID:#{order.id} | Name:#{order.event.name} | Quantity:#{order.quantity} | Purchased date:#{order.created_at} | Price: $#{order.price}"
    end
  end
  puts ""
end

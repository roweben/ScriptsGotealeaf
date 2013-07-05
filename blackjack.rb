def create_deck (deck)
  suits = ['Hearts', 'Clubs', 'Diamonds', 'Spades']
  cards = ['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace']
    #create deck of cards
  puts('Creating a new deck.')
  x=0
  for x in 0..suits.length-1
    y=0
    for y in 0..cards.length-1
      deck.push "#{cards[y]} of #{suits[x]}"
      y=y+1
    end
    x=x+1
  end
  deck
end

def shuffle_cards (deck, x=3)
  for x in 1..x
    deck.shuffle!
  end
  deck
end

def deal_a_card (deck, hand, hand_values)
  if deck.length == 0
    create_deck(deck)
  end
  hand.push deck[0] #deal first card in deck
  get_card_value(hand_values, deck[0])
  deck.shift #remove card just dealt from deck
end

def display_hand (player_name, hand)
  puts() #blank line
  puts("#{player_name}'s hand is:")
  puts(hand)
end

def get_card_value (hand_values, card)
  words = card.split(/ /)
  if words[0].length < 3
    hand_values.push words[0].to_i
  elsif words[0].length > 3
    hand_values.push 10
  else
    hand_values.push 11
  end
end

def get_aces(hand_values)
  aces = []
  for x in 0..hand_values.length-1
    if hand_values[x] == 11
      aces.push x
      return aces
    end
  end
  aces
end

def reduce_value_of_ace(hand_values, x)
  hand_values[x] = 1
end
  
def get_hand_status (hand_values)
  # active, blackjack or busted
  while get_hand_total(hand_values) > 21 && get_aces(hand_values).length > 0
    #reduce value of aces one at a time
    reduce_value_of_ace(hand_values, get_aces(hand_values)[0])
  end
  if  get_hand_total(hand_values) > 21
    hand_status = 'BUSTED'
  elsif get_hand_total(hand_values) == 21
    hand_status = 'BLACKJACK'
  elsif get_hand_total(hand_values) < 21
    hand_status = 'ACTIVE'
  end  
  hand_status
end

def get_hand_total (hand)
  y=0
  hand.each do |x| 
    y = y+x
  end
  y
end

  #create four decks
number_of_decks=4
decks = []
x = 1
for x in 1..number_of_decks
  deck = []
  create_deck(deck)
  shuffle_cards deck, 4 #shuffle cards 4 times
  decks.push deck
end

  #get player's name
print("What is your name:  ")
player_name = gets.chomp
  #greet player
puts #blank line
puts("Hello, #{player_name}, let's play blackjack!")

player_wants_to_play=true

while player_wants_to_play
  dealer_cards = []
  player_cards = []
  dealer_values = []
  player_values = []
  deck_to_use = rand(number_of_decks)
  deck = decks[deck_to_use]

    #deal first four cards
  deal_a_card(deck,player_cards,player_values)
  deal_a_card(deck,dealer_cards,dealer_values)
  deal_a_card(deck,player_cards,player_values)
  deal_a_card(deck,dealer_cards,dealer_values)

  display_hand(player_name, player_cards)
  player_wants_a_card=true
  until get_hand_status(player_values) == 'BLACKJACK' ||
    get_hand_status(player_values) == 'BUSTED' || player_wants_a_card == false
    print("#{player_name}, would you like another card?  Y/N:  ")
    player_reply = gets.chomp
    if player_reply.downcase == 'y'
      deal_a_card(deck,player_cards,player_values)
      display_hand(player_name, player_cards)
    else
      player_wants_a_card=false
    end
  end
  if get_hand_status(player_values) == 'BLACKJACK'
    puts("Congrats, #{player_name}, BLACKJACK!!!")
  elsif get_hand_status(player_values) == 'BUSTED'
    puts #blank line
    puts("Sorry, #{player_name}, you're busted!  Dealer wins.")
  elsif get_hand_status(player_values) == 'ACTIVE'
    puts() #blank line
    puts("Dealer's turn.")
    display_hand('Dealer', dealer_cards)
    while get_hand_total(dealer_values) < 17
      puts() #blank line
      puts("Dealer takes a card.")
      deal_a_card(deck,dealer_cards,dealer_values)
      if get_hand_total(dealer_values) > 21
        aces = get_aces(dealer_values)
        if aces.length > 0
          reduce_value_of_ace(dealer_values, aces[0])
        end
      end
      display_hand('Dealer', dealer_cards)
    end
    until get_hand_total(dealer_values) >= get_hand_total(player_values) ||
      get_hand_status(dealer_values) == 'BLACKJACK' ||
      get_hand_status(dealer_values) == 'BUSTED'
      puts() #blank line
      puts("Dealer takes a card.")
      deal_a_card(deck,dealer_cards,dealer_values)
      display_hand('Dealer', dealer_cards)
    end
    if get_hand_status(dealer_values) == 'BLACKJACK'
      puts("Congrats, DEALER, BLACKJACK!!!")
      puts() #blank line
    elsif get_hand_status(dealer_values) == 'BUSTED'
      puts() #blank line
      puts("Sorry, Dealer, you're busted!  #{player_name.upcase} wins.")
      puts() #blank line
      puts('SUMMARY OF HANDS:')
      display_hand(player_name, player_cards)
      display_hand('Dealer', dealer_cards)
    else
      puts() #blank line
      if get_hand_total(player_values) >= get_hand_total(dealer_values)
        if get_hand_total(player_values) > get_hand_total(dealer_values)
          puts("#{player_name.upcase} WINS!")
        else
          puts("Hand is a push.")
        end
      else
        puts('DEALER WINS!')
      end
      puts() #blank line
      puts('SUMMARY OF HANDS:')
      display_hand(player_name, player_cards)
      display_hand('Dealer', dealer_cards)
    end
  end  
  puts() #blank line
  print("#{player_name}, would you like to play again?  Y/N:  ")
  player_reply = gets.chomp
  if player_reply.downcase == 'n'
    player_wants_to_play=false
  else
    puts() #blank line
    puts('PLAYING AGAIN.')
    puts() #blank line
  end
end
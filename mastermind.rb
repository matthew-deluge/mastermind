# mastermind
require 'pry'
# allows for colored strings: https://stackoverflow.com/questions/1489183/colorized-ruby-output-to-the-terminal
class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

# the main game class, allows for player-guessing, computer-creating games
class Mastermind
  attr_reader :game_board, :result_board

  def initialize
    @game_board = []
    @result_board = []
    @player_input = []
    @turn = 0
    @colors = %w[r b y g]
    intro
    make_board
  end

  def intro
    puts "It's time for a game of"
    'Mastermind!'.split('').each do |letter|
      print letter
      sleep 0.2
    end
  end

  def make_board
    for i in 1..4 do
      @game_board.push(@colors.sample)
    end
  end

  def prompt_input
    puts "\nwhat is your guess?"
    @player_input = gets.chomp.split('')
    until @player_input.length == 4 && (@player_input - @colors == [])
      puts "Your guess must be four letter long, and made up of r, b, y, and g.\n Try again!"
      @player_input = gets.chomp.split('')
    end
    puts "\nYou guessed #{@player_input.join(' ')}"
  end

  def create_result(input_guess)
    @result_board = []
    temp_board = @game_board.clone
    temp_input = input_guess.clone
    temp_input.each_with_index do |choice, index|
      if choice == temp_board[index]
        @result_board.push("b")
        temp_board[index] = "Z"
        temp_input[index] = "X"
      end
    end
    temp_input.each do |choice|
      temp_board.each do |letter|
        if letter == choice
          @result_board.push("w")
          break
        end
      end
    end
    @result_board.sort
  end

  def check_win
    result_board == ['b', 'b', 'b', 'b'] 
  end

  def new_turn
    @player_input = []
  end

  def play
    until @turn == 12 || check_win
      puts "there are #{12 - @turn} turns left.\n"
      prompt_input
      create_result(@player_input)
      puts "You see #{@result_board.join(' ')}\n\n"
      new_turn
      @turn += 1
    end
    result = check_win ? 'You won! congrats!' : 'You lost, poor you!'
    puts result
  end
end

# Version of Mastermind where the computer guesses the code
class Computermind < Mastermind
  def initialize
    super
    @solutions = @colors.repeated_permutation(4).to_a
  end

  def make_board
    puts 'What is your secret code? Remember your code can include b, g, r, y, and must be four letters long!'
    @game_board = gets.chomp.split('')
    until @game_board.length == 4 && (@game_board - @colors == [])
      puts "Your code must be four letter long, and made up of r, b, y, and g.\n Try again!"
      @game_board = gets.chomp.split('')
    end
  end

  def computer_guess
    if @turn.zero?
      @player_input = %w[r r y y]
    else
      @solutions.delete_if { |solution| create_result(solution) == create_result(@player_input) }
      @player_input = @solutions[0]
    end
  end

  def play
    until @turn == 12 || check_win
      puts "there are #{12 - @turn} turns left."
      computer_guess
      puts "The computer guessed #{@player_input.join(' ')}, and your code is #{@game_board.join(' ')}"
      create_result(@player_input)
      puts "The computer sees: #{@result_board.join(' ')}"
      print 'calculating'
      for i in 1..10 do
        print '.'
        sleep 0.1
      end
      print "\n"
      @turn += 1
    end
    result = check_win ? 'The computer won! The apocalypse is here!!' : 'The computer lost! The singularity is avoided!'
    puts result
  end
end

puts "Welcome to Mastermind!\n
in this game, one playe comes up with a code using\n\n
#{'red'.red}, #{'green'.green}, #{'blue'.blue}, and #{'yellow'.yellow} pegs\n
Then, the other player guesses the code!\n
If they guessed a correct color in a correct spot, then they see a black ('b') peg\n
If they guessed a correct color in an incorrect spot, they see a white ('w') peg\n
They then get to guess again based on this information!\n
This repeats for twelve turns; if the guesser gets the code in that time, they win!"

puts "You have two options:\nTo break the code, input '1'\nTo make the code, input'2'"
input = gets.chomp
until ['1','2'].include?(input)
  puts "You have two options:\nTo break the code, input '1'\nTo make the code, input'2'"
  input = gets.chomp
end
case input
when '1'
  game = Mastermind.new
  game.play
when '2'
  game = Computermind.new
  game.play
end

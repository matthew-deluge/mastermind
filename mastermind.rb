# mastermind
require "pry"

class Mastermind
  attr_reader :game_board
  attr_reader :result_board

  def initialize
    @game_board = []
    @result_board = []
    @player_input = []
    @turn = 0
    @colors = ["r","b","y","g"]
    intro
    make_board
  end

  def intro
    puts "It's time for a game of"
    "Mastermind!\n".split("").each do |letter| 
      print letter
      sleep 0.2
    end 
  end

  def make_board
    for a in 1..4 do
      @game_board.push(@colors.sample)
    end
  end

  def get_input
    puts "what is your guess?"
    @player_input = gets.chomp.split("")
    until @player_input.length == 4 && (@player_input - @colors == [])
      puts "Your guess must be four letter long, and made up of r, b, y, and g.\n Try again!"
      @player_input = gets.chomp.split("")
    end
    puts "you guessed #{@player_input}"
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
    temp_input.each_with_index do |choice, index|
      for i in temp_board do
        if i == choice
          @result_board.push("w")
          break
        end
      end
    end
    @result_board.sort
  end

  def check_win
    return result_board == ["b","b","b","b"] 
  end

  def new_turn
    @player_input = []
  end

  def play
    until @turn == 12 || check_win
      puts "there are #{@turn} turns left."
      get_input
      create_result (@player_input)
      puts @result_board
      new_turn
      @turn += 1
    end
    result = check_win ? "You won! congrats!" : "You lost, poor you!"
    puts result
  end
end

class Computermind < Mastermind
  
  def initialize
    super
    @solutions = @colors.repeated_permutation(4).to_a
  end

  def make_board
    puts "What is your secret code? Remember your code can include b, g, r, y, and must be four letters long!"
    @game_board = gets.chomp.split("")
    until @game_board.length == 4 && (@game_board - @colors == [])
      binding.pry
      puts "Your code must be four letter long, and made up of r, b, y, and g.\n Try again!"
      @game_board = gets.chomp.split("")
    end
  end

  def computer_guess
    if @turn == 0
      for a in 1..4 do
        @player_input.push(@colors.sample)
      end
    else 
      @solutions.delete_if {|solution| create_result(solution) == create_result(@player_input)}
      @player_input = @solutions[0]
    end
    
  end

  def play
      until @turn == 12 || check_win
        puts "there are #{12 - @turn} turns left."
        computer_guess
        puts "The computer guessed #{@player_input}, and your code is #{@game_board}"
        create_result(@player_input)
        puts "The computer sees: #{@result_board}"
        sleep 0.2
        @turn += 1
      end
      result = check_win ? "The computer won! The apocalypse is here!!" : "The computer lost! The singularity is avoided!"
      puts result
  end

end

puts "Welcome to Mastermind! You have two options:\nTo break the code, input '1'\nTo make the code, input'2'"
input = gets.chomp
until input == "1"||input == "2"
  puts "You have two options:\nTo break the code, input '1'\nTo make the code, input'2'"
  input = gets.chomp
end
case input
when "1"
  game = Mastermind.new
  game.play
when "2"
  game = Computermind.new
  game.play
end


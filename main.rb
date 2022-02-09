require 'json'
require './serialization'

class Hangman
  include Serialization

  WORDS_FILE = File.open('word_list.txt')
  WORDS_LIST = WORDS_FILE.readlines.filter_map do |line|
    line.chomp if line.chomp.length.between?(5, 12)
  end

  def initialize
    @correct_letters = []
    @tries = 6
    start_game
    conclude
  end

  def start_game
    user_input = nil
    loop do
      user_input = input('Type 1 for new game or 2 to load a game').to_i
      break if user_input.positive?
    end
    @word = WORDS_LIST.sample if user_input == 1
    load if user_input == 2

    play
  end

  def play
    puts('_ ' * @word.length)

    until @tries.zero?
      break if word_guessed?

      player_guess = input('Enter any letter:')
      break if player_guess.length > 1

      puts(word_lines(player_guess))
    end
    save if player_guess.downcase == 'save'
  end

  def input(prompt)
    loop do
      puts prompt
      user_input = gets.chomp
      next if user_input.empty?

      return user_input
    end
  end

  def word_guessed?
    @word.split('').all? { |letter| @correct_letters.include?(letter) }
  end

  def make_word(guess)
    word_lines = ''
    @word.split('').each do |letter|
      @correct_letters << guess if guess == letter && !@correct_letters.include?(guess)
      word_lines += @correct_letters.include?(letter) ? letter : '_ '
    end
    word_lines
  end

  def word_lines(guess)
    made_word = make_word(guess)
    @tries -= 1 unless guess.nil? || @word.include?(guess)

    made_word
  end

  def display_game_over
    puts "You ran out of tries! The word was #{@word}"
  end

  def display_win
    puts 'Congrats! You guessed the word!'
  end

  def conclude
    @tries.zero? ? display_game_over : display_win
    @tries = 6
  end
end

Hangman.new

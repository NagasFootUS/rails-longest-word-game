require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @random = (0..8).map { ('a'..'z').to_a[rand(26)] }
  end

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    return word['found']
  end

  def point
       url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    return word['length']
  end

  # The method returns true if the block never returns false or nil
  def letter_in_grid
    @answer.chars.sort.all? { |letter| @random.include?(letter) }
  end

  def score
    @answer = params[:answer]
    @random = params[:grid]

    if !letter_in_grid
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{@random}."
    elsif !english_word
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif letter_in_grid && !english_word
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif letter_in_grid && english_word
      @result = "Congratulation! #{@answer.upcase} is a valid English word."
      @point = point
    end
  end
end

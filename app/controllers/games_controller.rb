require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @score = result
  end

  def check_grid(attempt, grid)
    attempt.upcase.chars.all? { |letter| attempt.upcase.chars.count(letter) <= grid.count(letter) }
  end

  def method_word_found?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.parse(url).open.read
    word = JSON.parse(user_serialized)
    word["found"]
  end

  def result
    the_result = { message: 'not in the grid', score: 0 } if check_grid(@word, @letters) == false
    the_result = { message: 'not an english word', score: 0 } if method_word_found?(@word) == false
    if check_grid(@word, @letters) && method_word_found?(@word)
      the_result = { message: 'well done', score: (@word.length * 10) }
    end
    return the_result
  end
end

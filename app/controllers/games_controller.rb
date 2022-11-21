require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = generate_grid(9)
    @start_time = Time.now
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    array = []
    contador = 0
    while contador < grid_size
      array << ("A".."Z").to_a.sample
      contador += 1
    end
    array
  end

  def score
    answer = params[:answer]
    letters = params[:letters].split
    start_time = Time.parse(params[:start_time])
    @hash = run_game(answer, letters, start_time)
    console
  end

  def run_game(attempt, grid, start_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    end_time = Time.now
    user_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    user = JSON.parse(user_serialized)
    cheq = grid(grid, attempt)
    hash = prueba(user, cheq, attempt, end_time, start_time)
    hash[:score] = 0 if hash[:score].nil?
    hash[:time] = start_time - end_time
    hash
  end

  def grid(grid, attempt)
    cheq = nil
    split_attempt = attempt.upcase.chars
    puts grid
    split_attempt.each do |element|
      if grid.include?(element)
        grid.delete_at(grid.find_index(element))
      else
        cheq = false
      end
    end
    cheq
  end

  def prueba(user, cheq, attempt, end_time, start_time)
    hash = {}
    if user["found"] == false
      hash[:message] = "the given word is not an english word"
    elsif cheq == false
      hash[:message] = "the given word is not in the grid"
    else
      hash[:message] = 'well done'
      hash[:score] = (100 / (end_time - start_time).to_f) + (attempt.length * 10)
    end
    hash
  end

end

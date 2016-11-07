class GameController < ApplicationController
  def game
    @grid = generate_grid(9)
    @start_time = Time.now.to_i
  end

  def score
    @end_time = Time.now
    run_game(params[:word], params[:grid].split(""), Time.at(params[:start_time].to_i), @end_time)
  end

  def generate_grid(grid_size)
    grid = []
    grid_size.to_i.times do
      letter = ("A".."Z").to_a.sample
      grid << letter
    end
    return grid.join
  end

  def run_game(attempt, grid, start_time, end_time)
    @result = {}
    @result[:time] = (end_time - start_time.to_time).to_f

    # raise
    letter_frequency(attempt.upcase.split("")).each do |letter, freq|
      if freq <= letter_frequency(grid)[letter]
        next
      else
        @result[:score] = 0
        @result[:message] = "not in the grid"
        return @result
      end
    end
    # raise

    if translator(attempt) == nil
      @result[:score] = 0
      @result[:message] = "not an English word"
    else
      @result[:score] = (attempt.upcase.split("").size.to_f - (@result[:time].to_f / 100).to_f).round(2)
      @result[:score] > 1 ? @result[:message] = "well done" : @result[:message] = "Meh"
      @result[:translation] = translator(attempt)
    end

    return @result

    # TODO: runs the game and return detailed hash of result
  end

  def letter_frequency(array)
    hsh = Hash.new(0)
    array.each do |letter|
      hsh[letter] += 1
    end
    return hsh
  end

  def translator(word)
    api_key = "84457b90-958c-48c3-9418-aec56efb36d9"
    begin
      response = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{word}")
      json = JSON.parse(response.read.to_s)
      if json['outputs'] && json['outputs'][0] && json['outputs'][0]['output'] && json['outputs'][0]['output'] != word
        return json['outputs'][0]['output']
      end
    rescue
      if File.read('/usr/share/dict/words').upcase.split("\n").include? word.upcase
        return word
      else
        return nil
      end
    end
  end





end

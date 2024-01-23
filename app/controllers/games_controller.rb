class GamesController < ApplicationController
  before_action :set_letters, only: [:new, :score]
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.sample }
  end

  def score
    submitted_word = params[:word].upcase
    if valid_word?(submitted_word, @letters)
      score = calculate_score(submitted_word)
      flash[:success] = "Congratulations! Your word '#{submitted_word}' is valid. Your score is #{score}."
    else
      flash[:error] = "Sorry, '#{submitted_word} is not a valid word. Please use only the provided letters."
    end

    redirect_to action: :new
  end

  private

  def set_letters
    @letters = session[:letters] || Array.new(10) { ('A'..'Z').to_a.sample }
    session[:letters] = @letters
  end

  def valid_word?(word, letters)
    word.chars.all? { |char| letters.include?(char) }
  end

  def calculate_score(word)
    word.length
  end

  def valid_english_word?(word)
    api_key = ':6540975'
    api_url = 'https://wagon-dictionary.herokuapp.com/'

    uri = URI(api_url)
    response = Net::HTTP.get(uri)
    json_response = JSON.parse(response)

    json_response.is_a?(Array) && !json_response.empty?
  end
end

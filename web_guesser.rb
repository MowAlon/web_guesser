require 'sinatra'
require 'sinatra/reloader'

set :number, rand(101)

def check_guess(guess)
  guess = guess.to_i
  message = if guess == settings.number
     "Whoa, dude... good guess. You got it right!"
  elsif guess > settings.number
    guess - settings.number > 5 ? "Way too high!" : "Too high!"
  else
    settings.number - guess > 5 ? "Way too low!" : "Too low!"
  end
end

get '/' do
  guess = params['guess']
  message = check_guess(guess)

  erb :index, :locals => {:number => settings.number, :message => message}
end

require 'sinatra'
require 'sinatra/reloader'

set :number, rand(101)
set :status, :way_wrong

def check_guess(guess)
  guess = guess.to_i
  message = if guess == settings.number
    settings.status = :correct
     "Whoa, dude... good guess. You got it right!"
  elsif guess.between?(settings.number - 5, settings.number + 5)
    settings.status = :close
    guess < settings.number ? "Too low!" : "Too high!"
  else
    guess < settings.number ? "Way too low!" : "Way too high!"
  end
end

get '/' do
  guess = params['guess']
  message = check_guess(guess)

  erb :index, :locals => {:number => settings.number, :message => message, :status => settings.status}
end

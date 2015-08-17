require 'sinatra'
require 'sinatra/reloader'

set :number, rand(101)
set :status, :start
@@count = 5

def check_guess(guess)
  guess = guess.to_i
  message = if guess == settings.number
    settings.status = :correct
     "Whoa, dude... good guess. You got it right! Try another if you'd like."
  elsif guess.between?(settings.number - 5, settings.number + 5)
    settings.status = :close
    guess < settings.number ? "Too low!" : "Too high!"
  else
    settings.status = :way_wrong
    guess < settings.number ? "Way too low!" : "Way too high!"
  end
end

def reset_message(condition)
  if condition == :win
    "The SECRET NUMBER is #{settings.number}"
  else
    "You lose. Try again with a new secret number!"
  end
end

def reset
  settings.number = rand(101)
  @@count = 5
end

get '/' do
  guess, cheat = params['guess'], params['cheat']
  if !guess.nil?
    message = check_guess(guess)
    @@count -= 1
    extra_message = if settings.status == :correct
      reset_message(:win)
    elsif @@count == 0
      reset_message(:lose)
    end
    reset if extra_message
  end
  extra_message = reset_message(:win) if cheat == 'true'

  erb :index, :locals => {:number => settings.number, :message => message, :status => settings.status, :count => @@count, :extra_message => extra_message}
end

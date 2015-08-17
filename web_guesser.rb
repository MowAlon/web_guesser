require 'sinatra'
require 'sinatra/reloader'

set :number, rand(101)
set :status, :start
@@count = 5

def check_guess(guess)
  guess = guess.to_i
  message = if guess == settings.number
    settings.status = :correct
     "Whoa, dude... good guess. You got it right!"
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
    "The SECRET NUMBER is #{settings.number}. Try another if you'd like."
  else
    "You lose. Try again with a new secret number!"
  end
end

def reset
  settings.number = rand(101)
  @@count = 5
end

get '/' do
  guess = params['guess']
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

  erb :index, :locals => {:number => settings.number, :message => message, :status => settings.status, :count => @@count, :extra_message => extra_message, :guess => guess}
end

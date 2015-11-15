Rails.application.routes.draw do
  namespace :user do
    get '/register' => 'user#register'
  end
end

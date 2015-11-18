Rails.application.routes.draw do
  namespace :user do
    post '/register' => 'user#register'
    post '/login'    => 'user#login'
  end
end

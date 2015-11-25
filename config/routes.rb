Rails.application.routes.draw do
  scope '/api/v1' do
    namespace :user do
      post '/register' => 'user#register'
      post '/login' => 'user#login'
      post '/logout' => 'user#logout'
      get '/confirm/:token' => 'user#confirm'
      post '/request' => 'user#request_recovery'
      post '/recovery' => 'user#recovery'
    end
  end
end

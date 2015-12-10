Rails.application.routes.draw do
  scope '/api/v1' do
    namespace :user do
      post '/register' => 'user#register'
      post '/login' => 'user#login'
      post '/logout' => 'user#logout'
      get '/confirm/:token' => 'user#confirm'
      post '/request' => 'user#request_recovery'
      post '/recovery' => 'user#recovery'
      patch '/pin' => 'user#pin_set'
      get '/pin' => 'user#pin_check'
    end

    namespace :file do
      post '/photo' => 'photo#create'
      get '/photo' => 'photo#index'
      delete '/photo' => 'photo#delete'
    end
  end
end

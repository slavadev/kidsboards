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
      delete '/photo/:id' => 'photo#delete'
      delete '/photo' => 'photo#delete'
    end

    namespace :family do
      put '/' => 'family#family_update'
      get '/' => 'family#family_view'
      # adult
      post '/adult' => 'family#adult_create'
      put '/adult/:id' => 'family#adult_update'
      put '/adult' => 'family#adult_update'
      delete '/adult/:id' => 'family#adult_delete'
      delete '/adult' => 'family#adult_delete'
      # child
      post '/child' => 'family#child_create'
      put '/child/:id' => 'family#child_update'
      put '/child' => 'family#child_update'
      delete '/child/:id' => 'family#child_delete'
      delete '/child' => 'family#child_delete'
    end
  end
end

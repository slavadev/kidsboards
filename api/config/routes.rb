Rails.application.routes.draw do
  scope '/v1' do
    namespace :user do
      post '/register' => 'user#register'
      post '/login' => 'user#login'
      post '/logout' => 'user#logout'
      get '/confirm' => 'user#confirm'
      post '/request' => 'user#request_recovery'
      post '/recovery' => 'user#recovery'
      patch '/pin' => 'user#pin_set'
      get '/pin' => 'user#pin_check'
    end

    namespace :uploaded do
      post '/photo' => 'photo#create'
      get '/photo' => 'photo#index'
      delete '/photo/:id' => 'photo#delete'
      delete '/photo' => 'photo#delete'
    end

    namespace :family do
      put '/' => 'family#update'
      get '/' => 'family#view'
      # adult
      post '/adult' => 'adult#create'
      put '/adult/:id' => 'adult#update'
      put '/adult' => 'adult#update'
      delete '/adult/:id' => 'adult#delete'
      delete '/adult' => 'adult#delete'
      # goal
      post '/child/:id/goal' => 'goal#create'
      post '/child/goal' => 'goal#create'
      get '/child/:id/goal' => 'goal#index'
      get '/child/goal' => 'goal#index'
      # child
      post '/child' => 'child#create'
      put '/child/:id' => 'child#update'
      put '/child' => 'child#update'
      delete '/child/:id' => 'child#delete'
      delete '/child' => 'child#delete'
    end

    namespace :goal do
      get '/:id' => 'goal#view'
      get '/' => 'goal#view'
      put '/:id' => 'goal#update'
      put '/' => 'goal#update'
      delete '/:id' => 'goal#delete'
      delete '/' => 'goal#delete'
      patch '/:id/points' => 'goal#points_update'
      patch '/points' => 'goal#points_update'
    end
  end

  get '/loaderio-8fd226ca0551bbb679e5234f2b165e72' => 'user/user#loader'
end

FMRails::Application.routes.draw do
  namespace :home do
    get :index
    get :login
    get :logout
  end
  
  namespace :counter do
    get :day
    
    get :season
    post :season_update_league_teams
    post :season_draw_league
  end
  
  resources :games do
    collection do
      get :simulate # TODO remove, just for debugging
    end
  end

  resources :countries do
    collection do
      get :coefficients
    end
  end
  
  resources :leagues do
    member do
      get :games
    end
  end
  
  resources :teams do
    member do
      get :squad
      get :tactics
    end
  end
  
  resources :player_names do
    collection do
      get :stats
      get :update_names
    end
  end
  
  resources :tactics do
  end
  
  resources :players do
  end
  
  resources :users do
    collection do
      get :select_team
      post :update_team
    end
  end
  
  get "oauths/oauth"
  get "oauths/callback"
  match "oauth/callback" => "oauths#callback"
  match "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  match 'login' => 'user_sessions#create', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'register' => 'users#new', :as => :register
  
  root :to => 'home#index'
end

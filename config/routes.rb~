DefuzeMe::Application.routes.draw do

  # User signup & login
  resources :users, :except => :index
  resource :session, :only => [:new, :create, :destroy]

  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil

  # Admin panel
  match 'admin' => 'home#admin', :as => :admin
  namespace :admin do
    resources :users
  end

  root :to => "home#index"
end

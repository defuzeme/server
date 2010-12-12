DefuzeMe::Application.routes.draw do
  # Add locale filter (defuze.me/fr/users/...)
  filter 'locale'

  # User signup & login
  resources :users, :except => [:index, :new]
  resource :session, :only => [:create]
  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil


  match 'dashboard' => 'home#dashboard'
  resources :radios, :except => :index do
    get :delete, :on => :member
  end

  # Admin panel
  match 'admin' => 'home#admin', :as => :admin
  namespace :admin do
    resources :users
  end

  root :to => "home#index"
end

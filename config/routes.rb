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


  # Dashboard
  match 'dashboard' => 'home#dashboard'
  resources :radios, :except => :index do
    get :delete, :on => :member
  end

  # Invitations
  resources :invitations, :only => [:show, :new, :create]

  # Static pages
  match 'license' => 'home#license', :as => :license
  match 'overview' => 'home#overview', :as => :overview
  match 'contact' => 'home#contact', :as => :contact

  # Admin panel
  match 'admin' => 'home#admin', :as => :admin
  namespace :admin do
    resources :users
  end

  root :to => "home#index"
end

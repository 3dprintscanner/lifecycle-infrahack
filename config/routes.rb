Rails.application.routes.draw do
  resources :journeys
  devise_for :owners
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :consumptions
  resources :owners
  resources :vehicles
  resources :journeys
  
  get '/overview', to: 'overviews#index'
  get '/charging', to: 'charging#show'

  root :controller => 'overviews', :action => 'index' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, :format => :json do
    namespace :v1 do
      get  '/chargedata', to: 'chargedata#index'
      post  '/submitdata', to: 'chargedata#submitdata'
      post  '/consumption', to: 'consumption#create'
      post  '/journey', to: 'journey#create'
    end
  end
end

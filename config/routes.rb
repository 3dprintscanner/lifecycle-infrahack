Rails.application.routes.draw do
  resources :consumptions
  resources :owners
  resources :vehicles
  
  get '/overview', to: 'overviews#index'
  root :controller => 'overviews', :action => '/' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, :format => :json do
    namespace :v1 do
      get  '/chargedata', to: 'chargedata#index'
      post  '/submitdata', to: 'chargedata#submitdata'
    end
  end
end

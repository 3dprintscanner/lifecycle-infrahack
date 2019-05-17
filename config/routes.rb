Rails.application.routes.draw do
  resources :consumptions
  resources :owners
  resources :vehicles
  
  get '/overview', to: 'overviews#index'
  root :controller => 'overviews', :action => '/' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

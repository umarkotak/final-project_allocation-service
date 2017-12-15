Rails.application.routes.draw do
  root 'home#index' 

  resources :driver_locations
end

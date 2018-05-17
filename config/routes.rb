Rails.application.routes.draw do
  resources :preferences
  
  post 'preferences/test', to: "preferences#test"

 end
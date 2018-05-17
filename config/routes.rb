Rails.application.routes.draw do
  resources :preferences
  
  post 'preferences/test', to: "preferences#test"
  
  get 'preferences/results', to: "preferences#results"

 end
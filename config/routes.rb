Rails.application.routes.draw do
  get 'dashboard/index'
  post 'dashboard/index'

  resources :organizations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root :to => "dashboard#index" 
end

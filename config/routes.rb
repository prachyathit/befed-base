Rails.application.routes.draw do

  resources :restaurants do
    resources :foods
  end
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root                  'restaurants#index'
  get     'help'    =>  'static_pages#help'
  get     'about'   =>  'static_pages#about'
  get     'contact' =>  'static_pages#contact'
  get     'signup'  =>  'users#new'
  get     'login'   =>  'sessions#new'
  post    'login'   =>  'sessions#create'
  delete  'logout'  =>  'sessions#destroy'
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
end

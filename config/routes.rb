Rails.application.routes.draw do
  resources :orders, only: [:index, :show, :edit, :update, :destroy]
  resources :places
  post '/submitsaddress' => 'saddress#create', :as => :submit_saddress
  get 'saddress/new'
  put 'saddress/update'

  resources :options do
    resources :option_values, only: [:create, :destroy]
  end

  resources :categories
  resources :restaurants do
    resources :foods
  end
  get '/payment' => 'payments#index'
  # get '/orderstat' => 'orders#stat'
  get '/orderfood' => 'order_foods#index'
  get '/checkout' => 'cart#checkout'
  post '/checkout/complete' => 'cart#submit'
  get '/checkout/complete' => 'saddress#new'

  get '/cart' => 'cart#index'
  get '/cart/clear' => 'cart#clear_cart'
  get '/cart/:id' => 'cart#add_new', :as => :add_new
  post '/addcart' => 'cart#add_create', :as => :add_create
  get '/cart/line_delete/(:id)' => 'cart#line_delete', :as => :line_delete
  get 'users/edit_address' => 'users#edit_address', :as => :edit_user_address

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root                  'saddress#new'
  get     'terms' =>  'static_pages#terms'
  get     'privacy' =>  'static_pages#privacy'
  get     'help'    =>  'static_pages#help'
  get     'about'   =>  'static_pages#about'
  get     'contact' =>  'static_pages#contact'
  get     'signup'  =>  'users#new'
  get     'login'   =>  'sessions#new'
  post    'login'   =>  'sessions#create'
  delete  'logout'  =>  'sessions#destroy'
  resources :users
  resources :addresses do
    member do
      post :set_default
    end
  end
  resources :password_resets, only: [:new, :create, :edit, :update]

  namespace :api do
    post    :login,     to: 'sessions#create'
    delete  :logout,    to: 'sessions#destroy'
    post    :register,  to: 'users#create'
    post    :checkout,  controller: 'cart'
    resources :users, only: [:show, :update] do
      resources :addresses, only: [:index, :show, :create, :update, :destroy]
      resources :orders, only: [:index]
      get :delivery_fee
    end

    resources :restaurants, only: [:index, :show] do
      get :check_valid_address
      resources :menu, only: [:index, :show] do
        get :options
      end
    end
  end
end

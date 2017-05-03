Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find',          to: 'merchants#show'
      get '/merchants/find_all',      to: 'merchants#index'
      get '/invoices/find',           to: 'invoices#show'
      get '/invoices/find_all',       to: 'invoices#index'
      get '/invoices/random',         to: 'invoices#show'
      get '/invoice_items/find_all',  to: 'invoice_items_find#index'
      get '/invoice_items/find',      to: 'invoice_items_find#show'
      get '/invoice_items/random',      to: 'invoice_items_random#show'

      resources :merchants, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
    end
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/items/find', to: 'items#show'
      get '/items/find_all', to: 'items#index'
      get '/items/random', to: 'items#show'
      get '/merchants/find', to: 'merchants#show'
      get '/merchants/find_all', to: 'merchants#index'
      get '/merchants/random', to: 'merchants#show'
      get '/invoices/find', to: 'invoices#show'
      get '/invoices/find_all', to: 'invoices#index'
      get '/invoices/random', to: 'invoices#show'
      get '/customers/find_all', to: 'customers_find#index'
      get '/customers/find', to: 'customers_find#show'
      get '/customers/random', to: 'customers_random#show'
      get '/invoice_items/find_all', to: 'invoice_items_find#index'
      get '/invoice_items/find', to: 'invoice_items_find#show'
      get '/invoice_items/random', to: 'invoice_items_random#show'
      get '/transactions/find', to: 'transactions_find#show'
      get '/transactions/find_all', to: 'transactions_find#index'
      get '/transactions/random', to: 'transactions#show'

      resources :merchants, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end

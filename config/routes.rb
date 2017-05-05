Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/items/find', to: 'items_find#show'
      get '/items/find_all', to: 'items_find#index'
      get '/items/random', to: 'items_random#show'
      get '/items/most_items', to: 'items_most_items#index'
      get '/items/:id/merchant', to: 'item_merchants#show'
      get '/items/:id/invoice_items', to: 'item_invoice_items#index'
      get '/items/most_revenue', to: 'items_most_revenue#index'

      get '/merchants/find', to: 'merchants#show'
      get '/merchants/find_all', to: 'merchants#index'
      get '/merchants/random', to: 'merchants#show'
      get '/merchants/:id/revenue', to: 'merchants_revenue#show'
      get '/merchants/revenue', to: 'merchants_revenue#index'
      get '/merchants/most_revenue', to: 'merchants_revenue#index'
      get '/merchants/most_items', to: 'merchants_most_items#index'
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/merchants/:id/invoices', to: 'merchant_invoices#index'

      get '/invoices/find', to: 'invoices#show'
      get '/invoices/find_all', to: 'invoices#index'
      get '/invoices/random', to: 'invoices#show'
      get '/invoices/:id/transactions', to: 'invoice_transactions#index'
      get '/invoices/:id/invoice_items', to: 'invoice_invoice_items#index'
      get '/invoices/:id/items', to: 'invoice_items_relationship#index'
      get '/invoices/:id/customer', to: 'invoice_customers#show'
      get '/invoices/:id/merchant', to: 'invoice_merchants#show'

      get '/customers/find_all', to: 'customers_find#index'
      get '/customers/find', to: 'customers_find#show'
      get '/customers/random', to: 'customers_random#show'
      get '/customers/:id/invoices', to: 'customers_invoices#index'
      get '/customers/:id/transactions', to: 'customer_transactions#index'

      get '/invoice_items/find_all', to: 'invoice_items_find#index'
      get '/invoice_items/find', to: 'invoice_items_find#show'
      get '/invoice_items/random', to: 'invoice_items_random#show'
      get '/invoice_items/:id/invoice', to: 'invoice_items_invoices#show'
      get '/invoice_items/:id/item', to: 'invoice_items_items#show'

      get '/transactions/find', to: 'transactions_find#show'
      get '/transactions/find_all', to: 'transactions_find#index'
      get '/transactions/random', to: 'transactions#show'
      get '/transactions/:id/invoice', to: 'transaction_invoices#show'

      resources :merchants, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end

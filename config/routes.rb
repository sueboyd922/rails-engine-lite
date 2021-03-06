Rails.application.routes.draw do
  # get "/api/v1/merchants", to: "api/v1/merchants#index"
  get "/api/v1/merchants/find", to: "api/v1/merchants#find"
  get "/api/v1/merchants/find_all", to: "api/v1/merchants#find_all"
  # get "/api/v1/merchants/:id", to: "api/v1/merchants#show"
  get "/api/v1/merchants/:id/items", to: "api/v1/merchants/items#index"
  #
  # get "/api/v1/items", to: "api/v1/items#index"
  get "/api/v1/items/find", to: "api/v1/items#find"
  get "/api/v1/items/find_all", to: "api/v1/items#find_all"
  # get "/api/v1/items/:id", to: "api/v1/items#show"
  get "/api/v1/items/:id/merchant", to: "api/v1/item_merchant#show"
  # post "/api/v1/items", to: "api/v1/items#create"
  # put "/api/v1/items/:id", to: "api/v1/items#update"
  # delete "/api/v1/items/:id", to: "api/v1/items#destroy"

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      resources :items, only: [:index, :show, :update, :destroy, :create]
    end
  end
end

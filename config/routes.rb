Rails.application.routes.draw do
  get "/api/v1/merchants", to: "api/v1/merchants#index"
  get "/api/v1/items", to: "api/v1/items#index"
end

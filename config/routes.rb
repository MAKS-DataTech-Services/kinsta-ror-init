Rails.application.routes.draw do
  devise_for :users
  get "/", to: "hello_world#index"

  # for API
  namespace :api do
    namespace :v1, defaults: {format: :json} do
      resources :users, only: [] do
        collection do
          get 'show_info'
        end
      end
    end
  end
end
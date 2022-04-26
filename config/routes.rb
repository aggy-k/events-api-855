Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # namespace :admin do
  #   # /admin/events
  #   resources :events
  # end

  # # /events
  # resources :events

  # baseUrl/api/v1/
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'login', to: 'sessions#login', as: :login

      resources :events, only: [:index] # api/v1/events
    end
  end
end

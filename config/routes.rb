Rails.application.routes.draw do
  resources :users, only: :index do
    collection do
      get :search
    end
  end
end

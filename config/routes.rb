Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    # Redirects signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  root 'todos#index'

  resources :todos do
    patch :update_category, on: :member
  end

  resources :categories
end

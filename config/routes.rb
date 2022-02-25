Rails.application.routes.draw do
  root 'todos#index' 
  resources :todos do
    patch :change_status, on: :member
   end
end

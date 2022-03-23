Rails.application.routes.draw do
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
root to: 'tops#top'

get 'login', to: 'user_sessions#new', as: :login
post 'login', to: "user_sessions#create"
delete 'logout', to: 'user_sessions#destroy', as: :logout

resources :relationships, only: [:create, :destroy]
resources :users do
  collection do
    resources :likes, only: %i[create destroy]
  end
end
resources :posts
# config/routes.rb
resources :password_resets, only: [:new, :create, :edit, :update]

end

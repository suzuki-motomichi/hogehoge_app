Rails.application.routes.draw do
root to: 'tops#top'

get 'login', to: 'user_sessions#new', as: :login
post 'login', to: "user_sessions#create"
delete 'logout', to: 'user_sessions#destroy', as: :logout

resources :users do
  collection do
    resources :likes, only: %i[create destroy]
  end
end
resources :posts

end

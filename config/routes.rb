Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :friendships

  resources :activities

  resources :places

  resources :sports

  resources :users

  resources :teams

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get 'profile' => 'dashboard#profile'
  get 'list_user_activities' => 'dashboard#list_user_activities'
  get 'list_user_friends' => 'dashboard#list_user_friends'
  get 'list_user_teams' => 'dashboard#list_user_teams'

  get 'friendships/:id/accept' => 'friendships#accept', as: :accept
  get 'friendships/:id/add_friend' => 'friendships#add_friend', as: :add_friend
  get 'sports/:id/leaderboard' => 'dashboard#leaderboard', as: :leaderboard
  get 'activities/:id/join_in' => 'activities#join_in', as: :join_in


  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

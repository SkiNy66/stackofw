Rails.application.routes.draw do

  use_doorkeeper
  concern :likable do
    member do
      post :like_up
      post :like_down
      post :like_cancel
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :questions, concerns: :likable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers, concerns: :likable, shallow: true do #only: [:new, :create, :destroy]
      resources :comments, only: :create, defaults: { commentable: 'answers' }
      member do
        patch 'mark_best'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :users, on: :collection
      end
      resources :questions, only: [:index, :show]
      resources :answers, only: [:index]
    end
  end

  get "oauth/new_email_for_oauth", as: 'new_email_for_oauth'
  post "oauth/save_email_for_oauth", as: 'save_email_for_oauth'

  root to: "questions#index"
  resources :attachments, only: :destroy

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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

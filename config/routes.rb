Spree::Core::Engine.routes.prepend do
  resources :addresses do
    collection do
      get :search
      post :search
    end
  end
end

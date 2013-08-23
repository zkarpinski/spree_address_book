Spree::Core::Engine.routes.draw do
  resources :addresses

  namespace :admin do
    post 'addresses/search' => 'addresses#search', as: 'address_search'
    delete 'addresses/:id' => 'addresses#destroy', as: 'address'
  end
end

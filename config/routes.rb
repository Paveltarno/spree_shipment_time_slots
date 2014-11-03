Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :shipment_time_slots
  end
end

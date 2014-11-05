Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :shipment_time_slots
    resources :time_slot_day_plans
    resources :shipment_time_slot_single_plans, only: [:new, :destroy]
  end
end

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :shipment_time_slots
    resources :time_slot_day_plans

    # RegularPlan
    get '/regular_plans' => 'regular_plans#index'
    post '/regular_plans' => 'regular_plans#update'

  end
end

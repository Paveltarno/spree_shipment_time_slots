Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :shipment_time_slots, only: [:index, :show]
    resources :time_slot_day_plans

    # CustomPlanSets
    get '/custom_plans' => 'custom_plan_sets#edit'
    match '/custom_plans', to: 'custom_plan_sets#update', via: [:post, :put, :patch]

    # RegularPlan
    get '/regular_plans' => 'regular_plans#index'
    match '/regular_plans', to: 'regular_plans#update', via: [:post, :put, :patch]

  end
end

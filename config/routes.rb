Rails.application.routes.draw do

  resources :services do
    resources :records, only: [:index, :show]
  end


end

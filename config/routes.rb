Rails.application.routes.draw do


  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :organizations, only: [:new, :create, :show, :index]

  # resources :services do
  #   resources :records, only: [:index, :show]
  # end
  get 'about_us' => 'pages#about_us'
  get 'faqs' => 'pages#faqs'
  get 'contact_us' => 'pages#contact_us'
root 'application#index'
  get "/services/new", to: "services#new"
  get "/services/:service_slug", to: "services#show"
  get "/services", to: "services#index"
  post "/services", to: "services#create"
  get "/services/:service_slug/edit", to: "services#edit"
  put "/services/:service_slug", to: "services#update"
  delete "/services/:service_slug", to: "services#destroy"
  match "/services/:service_slug", to: "services#show_header_metadata", via: [:options]


  match "/services/:service_slug", to: "services#show_header_metadata", via: [:options]


  get "/services/:service_slug/records", to: "records#index"


end

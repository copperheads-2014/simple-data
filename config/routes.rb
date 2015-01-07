Rails.application.routes.draw do


  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :organizations, only: [:new, :create, :show, :index]
  resources :versions, only: [:index, :show]

  get 'about_us' => 'pages#about_us'
  get 'faqs' => 'pages#faqs'
  get 'contact_us' => 'pages#contact_us'
  root 'application#index'
  get "/services/new", to: "services#new"
  get "/services/:service_slug", to: "services#show"
  get "/services", to: "services#index"
  post "/services", to: "services#create"
  get "/services/:service_slug/edit", to: "services#edit"
  match "/services/:service_slug", to: "services#update", via: [:put, :patch]
  put "/services/:service_slug/deactivate", to: "services#deactivate"
  put "/services/:service_slug/activate", to: "services#activate"
  match "/services/:service_slug", to: "services#show_header_metadata", via: [:options]
  get "/services/:service_slug/documentation", to: "services#documentation"

  match "/services/:service_slug", to: "services#show_header_metadata", via: [:options]

  get "services/:service_slug/versions", to: "versions#index"
  get "services/:service_slug/versions/:version_id", to: "versions#show"
  get "/services/:service_slug/:version/records", to: "records#index"

  get "versions/:version_id/headers/update", to: "headers#index"
  post "versions/:version_id/headers", to: "headers#create"

  resources :upload_csv, only: :index

end

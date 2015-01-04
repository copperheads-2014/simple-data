Rails.application.routes.draw do


  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :organizations, only: [:new, :create, :show, :index]

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

  get "/services/:service_slug/records", to: "records#index"

  resources :upload_csv, only: :index

end

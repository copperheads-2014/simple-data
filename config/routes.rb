Rails.application.routes.draw do
  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :organizations, only: [:new, :create, :show, :index]

  resources :services, param: :service_slug, except: [:destroy] do
    member do
      put :deactivate
      put :activate
      match "/", action: "show_header_metadata", via: [:options]
      get :documentation

      # Service versions
      resources :versions, only: [:index, :show], as: 'service_versions' do
        member do
          get "headers/update", to: "headers#index"
          post "headers", to: "headers#create"
        end
      end
      get "/:version/records", to: "records#index", as: 'version_records'
      get "/:version/report", to: "records#report", as: 'version_report'
    end
  end
  resources :upload_csv, only: :index

  # Marketing pages
  get 'about_us' => 'pages#about_us'
  get 'faqs' => 'pages#faqs'
  get 'contact_us' => 'pages#contact_us'

  root 'application#index'
end

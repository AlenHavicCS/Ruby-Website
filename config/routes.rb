Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  get "about", to: "pages#about"
  get "home", to: "pages#home"
  resources :projects, only: [:index, :new, :create, :edit], param: :slug do
    resources :comments, only: [:create]
  end
  resources :comments, only: [:destroy] do
    post :ban_ip, on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"

  # Each project gets a vanity URL at the root (e.g. /fishedex) instead of /projects/:id.
  # Update/destroy reuse the same vanity URL so form_with and project_path keep working.
  # Kept last so it doesn't shadow the named routes above.
  constraints(slug: /[a-z0-9]+(?:-[a-z0-9]+)*/) do
    get "/:slug", to: "projects#show", as: :project
    patch "/:slug", to: "projects#update"
    put "/:slug", to: "projects#update"
    delete "/:slug", to: "projects#destroy"
  end
end

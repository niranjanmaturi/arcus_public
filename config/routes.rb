Rails.application.routes.draw do
  devise_for :service_accounts, skip: :all
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :devices, only: [] do
    resources :templates, only: [] do
      resources :results, only: [:index]
    end
  end

  root to: redirect('/admin')
end

Yata::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', passwords: 'users/passwords' }

  resources :reminders, only: :index

  resources :tasks, except: :destroy do
    resources :shares, only: :create
    delete :clear, on: :collection
    patch :mark_as_done, on: :member
    patch :unmark_as_done, on: :member
  end

  resources :shares, only: [] do
    resource :accept, only: :show
  end

  root to: "tasks#index"
end

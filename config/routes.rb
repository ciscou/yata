Yata::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', passwords: 'users/passwords' }

  resources :reminders, only: :index

  resources :tasks do
    collection do
      get :delayed
      get :today
      get :tomorrow
      get :later
      get :unscheduled
      get :done
      get :by_category
      get :uncategorized
    end
    resources :sub_tasks, only: :update
    resources :shares, only: :create
    delete :clear, on: :collection
    patch :mark_as_done, on: :member
    patch :unmark_as_done, on: :member
  end

  resources :shares, only: [] do
    resource :accept, only: [:show, :create]
  end

  root to: "tasks#index"
end

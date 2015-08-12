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

      delete :clear
    end

    member do
      patch :mark_as_done
      patch :unmark_as_done
    end

    resources :sub_tasks, only: :update
    resources :shares, only: :create
  end

  resources :shares, only: [] do
    resource :accept, only: [:show, :create]
  end

  namespace :api do
    resources :tasks do
      member do
        post :mark_as_done
        post :unmark_as_done
      end
    end
  end

  root to: "tasks#index"
end

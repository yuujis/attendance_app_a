Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :base  do
  end
  
  resources :users do
    
    collection {post :import}
      get 'import', to: 'users#import'
    member do
      post '/user_edit', to: 'users#user_edit'
      get 'edit_overtime_info'
      patch 'update_overtime_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month' 
    end
    
    collection do #idを必要としない
      get 'employees'
    end
    
    resources :attendances, only: :update
      post 'overtime_superior'
    

  end
end
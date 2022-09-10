Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :base  
  
  resources :users do
    
    collection {post :import}
      get 'import', to: 'users#import'
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/edit_attendance_log'
      get 'attendances/edit_notice_overtime'
      get 'attendances/edit_change_attendance'
      post 'approvals/create'
      get 'approvals/edit'
    end
    
    collection do #idを必要としない
      get 'employees'
    end
    
    resources :attendances  do
      collection do
        get 'csv_output'
      end
      member do
        post 'overtime_superior'
        get 'edit_overtime_info'
        patch 'update_overtime_info'
        # 残業申請のお知らせモーダルの更新
        patch 'update_notice_overtime'
        # 勤怠変更申請のお知らせモーダルの更新
        patch 'update_change_attendance'

      end
    end
  end
  
  resources :attendances  do
    collection do
      get 'csv_output'
    end
  end

end
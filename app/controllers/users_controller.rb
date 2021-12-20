class UsersController < ApplicationController
  require 'csv'
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_overtime_info, :update_overtime_info, :user_edit] 
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_overtime_info, :update_overtime_info, :user_edit]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_overtime_info, :update_overtime_info, :employees, :user_edit]
  before_action :set_one_month, only: :show

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def import
    
    if params[:file].blank?
    flash[:warning] = "CSVファイルが選択されていません。"
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    flash[:success] =  "ユーザー場をインポートしました"
    redirect_to users_url
    end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def edit_basic_info
  end
  
  def user_edit
  end

  def employees
    @users = User.all.includes(:attendances)
  end
  
  def update_basic_info
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time,:superior,:admin )
    end

    def basic_info_params
      params.require(:user).permit(:affiliation, :basic_time, :work_time)
    end

end
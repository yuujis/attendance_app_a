class BaseController < ApplicationController
  before_action :set_base, only: [ :edit, :destroy] 
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:show, :edit, :update, :destroy]
  
  def index
  end
  
  def show
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点情報追加に成功しました。'
      redirect_to base_url(@base)
    else
      render :show
    end
  end
  
  def edit
  end

  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to base_url
    else
      flash[:warning] = "拠点情報変更できませんでした。"
      render :edit      
    end
  end
  
  def destroy
    @base.destroy
    flash[:danger] = "#{@base.name}を削除しました。"
    redirect_to base_url
  end
  

  private

    def base_params
      params.require(:base).permit(:id,:name,:btype)
    end


end

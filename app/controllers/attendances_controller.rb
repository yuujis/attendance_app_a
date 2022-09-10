class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_overtime_info, :update_overtime_info,:edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def import
    User.import(params[:file])
    redirect_to root_url
  end

  def edit_overtime_info
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # @overtimeapp = Attendance.update_attributes(params[overtime_info_params])
  
    # flash[:info] = "残業申請を送信しました。"
    # redirect_to @user
  end
    
  # 残業申請の更新処理
  def update_overtime_info
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @worktime = @user.designated_work_end_time
    
    if overtime_info_params.nil?
      if params[:attendance][:confirmation].blank?
        flash[:danger] = "上長が選択されていません。"
        redirect_to @user
      elsif @attendance.finished_at.blank?
        flash[:danger] = "退社時間が未入力です。"
        redirect_to @user
      elsif ((params[:attendance]["schedule(4i)"].to_i < @worktime.hour) &&
        params[:attendance][:next_day] == "false")
          flash[:danger] = "指定勤務終了時間より早い終了予定時間は無効です。"
          redirect_to @user
      else
        flash[:danger] = "申請情報に不正な入力があるため、残業申請できませんでした。"
        redirect_to @user
      end
    else
      @attendance.update(overtime_info_params)
      @attendance.update(overtime_confirm: "申請中", overtime_check: false)
      flash[:success] = "残業申請しました。"
      redirect_to @user
    end
  end
  
  # 残業申請のお知らせモーダル
  def edit_notice_overtime
    @notice_users = User.where(id: Attendance.where(name: current_user.name).where(overtime_check: false).where.not(endtime_at: nil).select(:user_id)).where.not(id: current_user)
    users(@notice_users)
  end
  
  # 残業申請お知らせの更新
  def update_notice_overtime
    # 前提:form_withのurl引数（@user）はbefore_actionの
    #      set_userによって「上長」のユーザー情報を得る。
    @notice_users = User.where(id: Attendance.where(overtime_check: false).where.not(endtime_at: nil).select(:user_id))
    users(@notice_users)
    if overtime_notice.updat.invalid?
      notice_overtime_params.each do |id, item|
        attendance = Attendance.find(id)
        if params[:attendance][:notice_attendances][id][:overtime_check] == "true"
          attendance.update_attributes(item)
        end
      end
      flash[:success] = "残業申請の変更を通知しました。</br>※変更にチェックがない申請は更新されていません。".html_safe
      redirect_to @user
    else
      flash[:danger] = "残業申請の変更ができませんでした。</br>※変更チェックボックスが選択されません。"
      redirect_to @user
    end
  end
  
  private

     def overtime_info_params
       params.permit(:schedule, :next_day,:confirmation)
     end


    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end

    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
end
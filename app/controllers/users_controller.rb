class UsersController < ApplicationController
  def index
    
  end

  def show
    params[:id] = params[:id] ? params[:id] : (current_user ? current_user.id : nil)
    @user = User.find_by_id(params[:id])
    
    if !@user
      page_not_found
    end
    
    @title_params = {
      :username => @user.username
    }
  end

  def edit
    @user = User.find(params[:id])
    
    @title_params = {
      :username => @user.username
    }
  end

  def update
    @user = User.find(params[:id]);
    @user.update_attributes(params[:user]);

    @res = @user.save

    respond_to do |format|
      format.html {
        if @res
          redirect_to @user, notice: I18n.t("messages.users.update.success")
        else
          @errors = @user.errors
          render action: "edit"
        end
      }
      format.json {
        if @res
          render :json => {
            :state => true,
            :user => @user
          }
        else
          render :json => {
            :state => false,
            :errors => @user.errors
          }
        end
      }
    end
  end

  def change_password
    @user = User.find(params[:id])
    
    @title_params = {
      :username => @user.username
    }
  end

  def update_password
    @user = User.find(params[:id])
    if (@user && User.authenticate(@user.username, params[:user][:old_password]))
      @user.password_confirmation = params[:user][:password_confirmation]
      # the next line clears the temporary token and updates the password
      @res = @user.change_password!(params[:user][:password])
      if !@res
        @user.errors.add(:password, I18n.t("messages.users.update_password.error") )
      end
    else
      @res = false
      @user.errors.add(:old_password, I18n.t("messages.users.update_password.wrong_old") )
    end

    respond_to do |format|
      format.html {
        if @res
          redirect_to @user, :notice => I18n.t("messages.users.update_password.success")
        else
          @errors = @user.errors
          render action: "change_password"
        end
      }
      format.json {
        if @res
          render :json => {
            :state => true,
            :user => @user
          }
        else
          render :json => {
            :state => false,
            :errors => @user.errors
          }
        end
      }
    end
  end

  def reset_password
    # jen renderuju formular
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @res = @user.save

    respond_to do |format|
      format.html {
        if @res
          redirect_to "/", notice: I18n.t("messages.users.create.success")
        else
          @errors = @user.errors
          render action: "new"
        end
      }
      format.json {
        if @res
          render :json => {
            :state => true,
            :user => @user
          }
        else
          render :json => {
            :state => false
          }
        end
      }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @res = @user.destroy

    respond_to do |format|
      format.html {
        redirect_to :back
      }
      format.json {
        render :json => {
          :status => @res
        }
      }
    end
  end

  def block
    @user = User.find(params[:id])
    
    params[:user][:block_expires_at_date] = params[:user][:block_expires_at_date] == "" ? "1900-01-01" : params[:user][:block_expires_at_date];
    params[:user][:block_expires_at_time] = params[:user][:block_expires_at_time] == "" ? "00:00:00" : params[:user][:block_expires_at_time];
    @user.block(params[:user][:block_expires_at_date] + " " + params[:user][:block_expires_at_time])

    redirect_to :back
  end

  def unblock
    @user = User.find(params[:id])
    @user.unblock

    redirect_to :back
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      UserMailer.activation_success_email(@user).deliver
      # presmeruju na seznam uzivatelu, pokud neni zdrojem aktivace email
      redirect_to "/home", notice: I18n.t("messages.base.user_activated")
    else
      not_authenticated
    end
  end
  
  def activate_manually
    @user = User.find(params[:id])
    @user.activate!

    redirect_to :back
  end
end

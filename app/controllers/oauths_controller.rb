class OauthsController < ApplicationController
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to :back, :notice => I18n.t("messages.oauths.callback.logged_in", provider: provider.titleize)
    else
      begin
        @user = create_from(provider) do |user|
          #validace username tak, aby se neopakovalo
          user.username = User.get_first_free_name(user.username)

          # pro twitter vytvorim vlastni email
          if (provider == "twitter")
            user.email = "#{user.username}@twitter.com"
          end

          true
        end

        @user.activate!

        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to :back, :notice => I18n.t("messages.oauths.callback.created", provider: provider.titleize, username: @user.username)
      end
    end

  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
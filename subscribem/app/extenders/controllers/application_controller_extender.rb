::ApplicationController.class_eval do
  def current_account
    if user_signed_in?
      @current_account ||= begin
        begin
          account_id = env['warden'].user(:scope => :account)
          Subscribem::Account.find(account_id)
        rescue ActiveRecord::RecordNotFound
          Subscribem::Account.find_by_subdomain!(request.subdomain)
        end
      end
    end
  end
  helper_method :current_account

  def current_user 
    if user_signed_in?
      @current_user ||= begin
        user_id = env['warden'].user(:scope => :user)
        Subscribem::User.find(user_id)
      end
    end
  end
  helper_method :current_user

  def user_signed_in?
    env['warden'].authenticated?(:user)
  end
  helper_method :user_signed_in?

  def authenticate_user!
    unless user_signed_in?
      flash[:info] = "Please sign in."
      redirect_to '/sign_in'
    end
  end

  def force_authentication!(user)
    env['warden'].set_user(user.id, :scope => :user)
  end

  def owner?
    current_account.owner?(current_user)
  end
  helper_method :owner?
end
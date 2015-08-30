class RegistrationsController < Devise::RegistrationsController

  protected
    def after_sign_up_path_for(resource)
      '/profile'
    end

  private

    def sign_up_params
      params.require(:user).permit(:name, :birth_date, :email, :password, :password_confirmation)
    end

end
class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(user)
    new_resident_path
  end
  
end

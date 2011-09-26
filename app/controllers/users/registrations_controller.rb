class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource
      resource.valid?
      resource.errors.add(:base, "Invalid recaptcha code. Please re-enter the code.")
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end
end

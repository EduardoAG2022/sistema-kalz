class Users::RegistrationsController < Devise::RegistrationsController
  def new
    redirect_to root_path, alert: "El registro no está habilitado."
  end

  def create
    redirect_to root_path, alert: "El registro no está habilitado."
  end
end

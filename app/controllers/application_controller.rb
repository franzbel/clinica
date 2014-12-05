class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

	protected 
    #Retorna el usuario que ha iniciado sesion, nil si no hay ninguno
    #Debido a que devuelve un objeto de User, puede llamar a los métodos de instancia de User, como 
    #current_user.email.
    def current_user
      return unless session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id]) 
    end
 
    # Hacemos que current_user este disponible en las plantillas como un helper
    helper_method :current_user
 
    # Filter method to enforce a login requirement
    # Apply as a before_filter on any controller you want to protect
    def authenticate
      logged_in? ? true : access_denied
    end
 
    # Metodo para determinar sin un usuario esta logeado
    def logged_in?
      current_user.is_a? User
    end
 
    # Hacemos que logged_in? este disponible en las plantillas como un helper
    helper_method :logged_in?
 
    def access_denied
      redirect_to login_path, :notice => "Porfavor inicie sesion para continuar" and return false
    end


end

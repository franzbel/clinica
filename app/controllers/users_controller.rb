class UsersController < ApplicationController
	before_action :authenticate, only: [:edit, :update]
	before_action :set_user, only: [:show, :edit, :update, :destroy, :numero_sesiones]


  def new
    	@user = User.new
  end
 
  	def create
    	@user = User.new(user_params)
    	if @user.save
      		redirect_to new_user_path, notice: 'Usuario ingresado con exito'
   		else
      		render action: :new
    	end
  	end
 
  	def edit
  		@user = current_user

      nuevo_valor=@user.sessions_number + 1
      @user.update_attribute(:sessions_number,  nuevo_valor)
      
  	end
 
	def update
		@user = current_user
    	if @user.update(user_params)
          if @user.rol== "doctor"
      		  redirect_to new_user_path, notice: 'Se actualizo la informacion con exito'
          else
            redirect_to results_path
          end
    	else
      		render action: 'edit'
    	end
  	end
 
  	private
 
  	def set_user
    	@user = current_user
  	end
 
  	def user_params
    	params.require(:user).permit(:email, :password, :password_confirmation, :rol, :sessions_number)
  	end
end

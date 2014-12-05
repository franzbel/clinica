class SessionsController < ApplicationController
	def create
	    if user = User.authenticate(params[:email], params[:password])
	        session[:user_id] = user.id
	        if user.rol == 'doctor'
	      	    if user.sessions_number.to_i == 0
	      			flash.now[:notice] = "Esta es tu primera sesion, necesitas cambiar tu password"
	      			redirect_to :controller => 'users', :action => 'edit', :id => user.id
	      		else
	      			redirect_to new_user_path#, :notice => "Inicio de sesion exitoso"	
	      		end
	      	else		
	      		if user.sessions_number.to_i == 0
	      			flash.now[:notice] = "Esta es tu primera sesion, necesitas cambiar tu password"
	      	  		redirect_to :controller => 'users', :action => 'edit', :id => user.id
	      		else
	      	   		redirect_to results_path#, :notice => "Cierre de sesion exitoso"
	      		end
	      	end
	    else
	      flash.now[:alert] = "Combinacion invalida de login/password"
	      render :action => 'new'
	    end
	end

	def destroy
		reset_session
		redirect_to root_path, :notice => "Cierre de sesion exitoso"
	end
end


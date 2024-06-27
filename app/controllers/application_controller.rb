class ApplicationController < ActionController::Base

  def authenticate!
		if current_user.nil?
			return redirect_to new_user_session_path
		end
	end
end

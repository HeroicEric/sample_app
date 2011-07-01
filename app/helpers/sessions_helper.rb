module SessionsHelper

	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= user_from_remember_token
	end

	def signed_in?
		# True if current user isn't nil
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		current_user = nil
	end

	private
		
		# The * allows us to pass in 2 element array instead of two variables
		# Ex: test(*[1, 3]) same as test(1, 3)
		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end

		# Returning [nil, nil] if cookies.signed... is nil fixes some testing
		# issues that can happen
		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end

end

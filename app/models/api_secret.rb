class ApiSecret < ApplicationRecord

	belongs_to :user 
	# @note This method is performing both authentication and authorization.  The user suspended
	# should be something added to the corresponding pundit policy.
	def self.authenticate_with_api_key!(request)
		user = authenticate_with_api_key(request)
		return false unless user.present?
		return false unless user.active?

		user
	end
	
	def self.authenticate_with_api_key(request)
		api_key = request.headers["Secret"].downcase
		return unless api_key

		api_secret = ApiSecret.includes(:user).find_by(secret: api_key)
		# return unless api_secret.user

		# guard against timing attacks
		# see <https://www.slideshare.net/NickMalcolm/timing-attacks-and-ruby-on-rails>
		secure_secret = ActiveSupport::SecurityUtils.secure_compare(api_secret.secret, api_key)
		return api_secret.user if secure_secret
	end

end

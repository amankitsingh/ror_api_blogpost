class ApiSecret < ApplicationRecord

	has_one :user, foreign_key: "id"

	# @note This method is performing both authentication and authorization.  The user suspended
	# should be something added to the corresponding pundit policy.
	def self.authenticate_with_api_key!(request)
		@user ||= authenticate_with_api_key(request)
		return false unless @user
		return false if @user.suspended?

		true
	end
	
	def self.authenticate_with_api_key(request)
		api_key = request.headers["Secret"]
		return unless api_key

		api_secret = ApiSecret.includes(:user).find_by(secret: api_key)
		return unless api_secret

		# guard against timing attacks
		# see <https://www.slideshare.net/NickMalcolm/timing-attacks-and-ruby-on-rails>
		secure_secret = ActiveSupport::SecurityUtils.secure_compare(api_secret.secret, api_key)
		return api_secret.user if secure_secret
	end

end

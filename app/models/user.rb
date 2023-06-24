class User < ApplicationRecord


	has_many :api_secrets, foreign_key: "user_id", dependent: :delete_all

	enum role: {
		'Admin': 1,
		'User': 2
	}

	enum status:{
		'pending': 1,
		'active': 2,
		'suspended': 3
	}


	validates_format_of :first_name, with: /\A[\w\s]+\z/, on: :create, message: "is invalid"
	validates_format_of :last_name, with: /\A[\w\s]+\z/, on: :create, message: "is invalid"
	validates_format_of :email, with: /\A[[:alnum:]]+([a-zA-Z0-9\.\-\+\_\%]+)?[a-zA-Z0-9]+@[[:alnum:]]+[\-]?[a-z\d]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/i, on: :create, message: "is invalid"

	after_create :send_confirmation_email

	def send_confirmation_email
		ConfirmationMailer.welcome_email(self).deliver_later(wait: 5.seconds)
	end

	def self.get_user_details(id)
		user =  User.where(id: id)
		return user.take if user.present?
		{error: 'Not Found', status: 400}
	end

	def self.create_user(params)
		firstname = params[:firstname]
		lastname = params[:lastname]
		email = params[:email]
		begin
			user = User.create!(first_name: firstname, last_name: lastname, email: email, encrypted_password: SecureRandom.hex(10), role: "User")
			if user
				api_secret = ApiSecret.create!(secret: SecureRandom.hex, description: Faker::Markdown.emphasis, user_id: user.id)
			end
		rescue => e
			return {error: e.message.to_s, status: 400}
		end
		return searialized_response(user,api_secret)
	end

	def self.searialized_response(user, api_secret)
		{
			"User_details": user
		}
	end
	
end

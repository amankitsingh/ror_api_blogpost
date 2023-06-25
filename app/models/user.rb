class User < ApplicationRecord


	has_many :api_secrets, dependent: :delete_all
	has_many :article, dependent: :delete_all
	has_many :comments, dependent: :delete_all

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
		firstname = params[:firstname].downcase
		lastname = params[:lastname].downcase
		email = params[:email].downcase
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

	def self.confirm_user(confirm_id, present_user)
		if confirm_id == present_user.id
			if !present_user.active? and !present_user.suspended?
				present_user.active! 
				return {message: "User activated", status: 200}
			elsif present_user.active?
				return {message: "User already active", status: 200}
			elsif present_user.suspended?
				return {message: "User is suspended, contact admin", status: 200}
			end
		else
			{error: 'User not found', status: 400}
		end
	end

	def self.recover_user(params)
		first_name = params[:name].downcase
		email = params[:email].downcase
		last_remembered_api_key = params[:last_remembered_api_key].downcase
		user = User.where("first_name LIKE ?", "%#{first_name}%").where(email: email)
		
		if user.present?
			return {"User_details": user}
		else
			api_secret = ApiSecret.find_by(secret: last_remembered_api_key)
			if api_secret.present?
				if api_secret.user.email == email && [first_name].include?(api_secret.user.first_name)
					return {"User_details": api_secret.user}
				else
					return {error: 'User not found', status: 400}
				end
			else
				return {error: 'User not found', status: 400}
			end
		end

	end

	def self.admin_ban_user(user, ban_id)
		if user.Admin?
			user = User.find(ban_id)
			if user.present?
				user.suspended!
			else
				return {error: 'User not found', status: 400}
			end
			return searialized_response(user,nil)
		else
			return {error: 'uncharted territory', status: 400}
		end
	end

	def self.admin_status_user(user, status_id)
		if user.Admin?
			user = User.find(status_id)
			if user.present?
				return searialized_response(user,nil)
			else
				return {error: 'User not found', status: 400}
			end
		else
			return {error: 'uncharted territory', status: 400}
		end
	end

	def self.admin_activate_user(user, activete_id)
		if user.Admin?
			user = User.find(activete_id)
			if user.present?
				if user.active?
					return {error: 'User already active', status: 400}
				else
					user.active!
					return searialized_response(user,nil)
				end
			else
				return {error: 'User not found', status: 400}
			end
		else
			return {error: 'uncharted territory', status: 400}
		end
	end
	
end

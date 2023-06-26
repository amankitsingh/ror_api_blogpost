class User < ApplicationRecord
	include ActiveStorage::Blob::Analyzable

	has_many :api_secrets, dependent: :delete_all
	has_many :article, dependent: :delete_all
	has_many :comments, dependent: :delete_all
	has_one_attached :avatar

	validates_format_of :first_name, with: /\A[\w\s]+\z/, on: :create, message: "is invalid"
	validates_format_of :last_name, with: /\A[\w\s]+\z/, on: :create, message: "is invalid"
	validates_format_of :email, with: /\A[[:alnum:]]+([a-zA-Z0-9\.\-\+\_\%]+)?[a-zA-Z0-9]+@[[:alnum:]]+[\-]?[a-z\d]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/i, on: :create, message: "is invalid"
	
	after_create :send_confirmation_email

	enum role: {
		'admin': 1,
		'user': 2
	}

	enum status:{
		'pending': 1,
		'active': 2,
		'suspended': 3
	}

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
			user = User.create!(first_name: firstname, last_name: lastname, email: email, encrypted_password: SecureRandom.hex(10), role: "user")
			if user
				api_secret = ApiSecret.create!(secret: SecureRandom.hex, description: Faker::Markdown.emphasis, user_id: user.id)
			end
		rescue => e
			return {error: e.message.to_s, status: 400}
		end
		return searialized_response(user,api_secret)
	end

	def self.searialized_response(user, api_secret)
		result = {}
		result["User_details"]= user
		if api_secret.present?
			result["Api_details"] = api_secret
		end
		return result
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
		user = User.includes(:api_secrets).where("first_name LIKE ?", "%#{first_name}%").where(email: email).last
		
		if user.present?
			return searialized_response(user, user.api_secrets)
		else
			api_secret = ApiSecret.find_by(secret: last_remembered_api_key)
			if api_secret.present?
				if api_secret.user.email == email || [first_name].include?(api_secret.user.first_name)
					return searialized_response(api_secret.user, api_secret)
				else
					return {error: 'User not found', status: 400}
				end
			else
				return {error: 'User not found', status: 400}
			end
		end

	end

	def self.admin_ban_user(user, ban_id)
		if user.admin?
			user = User.where(id: ban_id).take
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
		if user.admin?
			user = User.where(id: status_id).take
			if user.present?
				return searialized_response(user.status, nil)
			else
				return {error: 'User not found', status: 400}
			end
		else
			return {error: 'uncharted territory', status: 400}
		end
	end

	def self.admin_activate_user(user, activete_id)
		if user.admin?
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

	def self.attach_avatar(user, params)
		begin
			if user.avatar.attached?
				user.avatar.purge
				user.avatar.attach(io: File.open(params[:avatar][:tempfile]), filename: "avatar_#{SecureRandom.hex(4)}")
				return {message: 'Avatar has been replaced successfully', status: 200}
			else
				user.avatar.attach(io: File.open(params[:avatar][:tempfile]), filename: "avatar_#{SecureRandom.hex(4)}")
				return {message: 'Avatar has been attached successfully', status: 200}
			end
		rescue => e
			return {error: 'there is some issue attaching the avatar', status: 400}
		end
	end

	def self.admin_get_all_user(params)
		if params.present?
			puts params
		end
		users = User.includes(:api_secrets).where(params).all.order(id: :asc)
		result = {}
		if users.present?
			users.each_with_index do |user, index|
				result[user.id] = searialized_response(user, user.api_secrets)
			end
			result[:status] = 200
		else
			return {error: 'No data found', status: 400}
		end
		return result
	end
	
	
end

module Index
	module V1
		class UserApi < Base
			version 'api', using: :path
			format :json
			
			desc 'get the user details'
			get 'user/details' do
				puts @user
				status 200
				body @user
			end

			desc "create a new user"
			params do
				requires :firstname, type: String
				requires :lastname, type: String
				requires :email, type: String
				optional :avatar, type: File
			end
			post 'user/create' do
				puts params.to_s
				obj = User.create_user(params)
				if obj.class == Hash
					status 200
					body obj
				else
					status 400
					body obj
				end
			end

		end
	end
end
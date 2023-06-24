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
			post 'user/create' do
			end

		end
	end
end
module Index
	module V1
		class User < Base
			version 'api', using: :path
			format :json
			
			desc 'get the user details'
			get 'user/:name' do
				puts params.to_s
				name = params[:name]
				message = "Hello #{name}! Hope you will enjoy!!!"
				response = {data: message, status: 200}
			end
		end
	end
end
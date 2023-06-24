module Index
	module V1
		class CategoryApi < Base
			version 'api', using: :path
			format :json
			
			desc 'get the user details'
			get 'category/:name' do
				puts params.to_s
				name = params[:name]
				message = "Hello #{name}! Hope you will enjoy!!!"
				response = {data: message, status: 200}
			end
		end
	end
end
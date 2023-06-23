module Index
	module V1
		class HelloWorld < Grape::API
			version 'api', using: :path
			format :json
			
			desc 'Hello World'
			get 'welcome-greeting/:name' do
				puts params.to_s
				name = params[:name]
				message = "Hello #{name}!"
				response = {data: message, status: 200, errors: []}
			end
		end
	end
end
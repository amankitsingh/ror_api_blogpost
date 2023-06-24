module Index
	module V1
		class HelloWorld < Base
			version 'api', using: :path
			format :json
			
			desc 'Hello World'
			get 'welcome-greeting/:name' do
				puts params.to_s
				name = params[:name]
				message = "Welcome Index Team. If you are seeing this message that means, your RoR app is up and running."
				name = "#{name}, Hope you are doing good today."
				response = {welcome: message,greeting: name}
			end
		end
	end
end
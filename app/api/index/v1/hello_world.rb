module Index
	module V1
		class HelloWorld < Base
			version 'api', using: :path
			format :json
			
			desc 'Hello World'
			get 'welcome-greeting' do
				puts @user
				message = "Welcome Index Team. If you are seeing this message that means, your RoR app is up and running."
				name = "#{@user.first_name}  #{@user.last_name}, Hope you are doing good today."
				response = {welcome: message,greeting: name}
			end
		end
	end
end
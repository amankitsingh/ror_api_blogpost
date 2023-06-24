class User < ApplicationRecord


	has_many :api_secrets, foreign_key: "user_id"

	enum role: {
		'Admin': 1,
		'User': 2
	}

	enum status:{
		'pending': 1,
		'active': 2,
		'suspended': 3
	}

end

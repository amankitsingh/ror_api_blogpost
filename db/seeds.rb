return if Rails.env.production?

# NOTE: when adding new data, please use the Seeder class to ensure the seed tasks
# stays idempotent.
require Rails.root.join("app/lib/seeder")

# we use this to be able to increase the size of the seeded DB at will
# eg.: `SEEDS_MULTIPLIER=2 rails db:seed` would double the amount of data
seeder = Seeder.new
SEEDS_MULTIPLIER = [1, ENV["SEEDS_MULTIPLIER"].to_i].max
puts "Seeding with multiplication factor: #{SEEDS_MULTIPLIER}\n\n"

# Disable Redis cache while seeding
Rails.cache = ActiveSupport::Cache.lookup_store(:null_store)

seeder.create_if_none(User) do

		3.times do
			User.create!(
				first_name: Faker::Name.first_name     ,
				last_name: Faker::Name.last_name,
				email: Faker::Internet.email,
				encrypted_password: Faker::Internet.password,
				role: ["user", "admin"].sample
			)
		end
end

seeder.create_if_none(ApiSecret) do
			2.times do
			ApiSecret.create!(
				secret: SecureRandom.hex,
				user_id: rand(1..3),
				description: Faker::Markdown.emphasis
			)
		end
	end
module Index
	module V1
		class CategoryApi < Base
			version 'api', using: :path
			format :json

			desc 'view all category'
			get 'category' do
				obj = Category.view_all_category
				status obj[:status]
				obj.delete(:status)
				body obj
			end
			
			desc 'get the category articles'
			params do
				requires :category, type: String
			end
			get 'category/:category' do
				puts params.to_s
				obj = Category.get_category_articles(@user, params[:category])
				status obj[:status]
				obj.delete(:status)
				body obj
			end

			desc 'get the category articles'
			params do
				requires :title, type: String
			end
			post 'category' do
				puts params.to_s
				obj = Category.create_new_category(@user, params[:title])
				status obj[:status]
				obj.delete(:status)
				body obj
			end

		end
	end
end
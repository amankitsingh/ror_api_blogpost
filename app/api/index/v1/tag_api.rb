module Index
	module V1
		class TagApi < Base
			version 'api', using: :path
			format :json
			
			desc 'get all tags'
			get 'tags' do
				obj = Tag.get_all_tags
				status obj[:status]
				obj.delete(:status)
				body obj
			end

			desc 'get single tags'
			params do
				requires :name, type: String
			end
			get 'tag/:name' do
				obj = Tag.single_tag_list(params[:name])
				status obj[:status]
				obj.delete(:status)
				body obj
			end

			desc "create new tag"
			params do
				requires :name, type: String
				requires :article_name, type: String
				optional :category, type: String
			end
			post 'tag' do
				obj = Tag.create_tag(@user, params)
				status obj[:status]
				body obj
			end

		end
	end
end
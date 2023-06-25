module Index
	module V1
		class CommentApi < Base
			version 'api', using: :path
			format :json
			
			desc 'create new comment for a article'
			params do
				requires :title, type: String
				requires :comment, type: String
			end
			post 'comment/create' do
				puts params.to_s
				obj = Comment.create_new_comment(@user, params)
				status obj[:status]
				obj.delete(:status)
				body obj
			end

			desc 'get all comment on all the article'
			params do
				optional :title, type: String
			end
			get 'comment/view' do
				puts params.to_s
				obj = Comment.view_all_comments(@user, params)
				status obj[:status] if obj[:status].present?
				obj.delete(:status)
				body obj
			end

			desc 'get comment on a article'
			params do
				optional :title, type: String
			end
			post 'comment/view' do
				puts params.to_s
				obj = Comment.view_all_comments(@user, params)
				status obj[:status] if obj[:status].present?
				obj.delete(:status)
				body obj
			end

			desc 'rate new a article'
			params do
				requires :title, type: String
				requires :rating, type: String
			end
			post 'comment/rate' do
				puts params.to_s
				obj = Comment.rate_article(@user, params)
				status obj[:status]
				obj.delete(:status)
				body obj
			end

		end
	end
end
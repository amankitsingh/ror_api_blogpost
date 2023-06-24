module Index
	module V1
		class ArticleApi < Base
			version 'api', using: :path
			format :json
			
			desc 'get the user details'
			get 'articles' do
				obj = Article.get_all_articles(@user)				
				status obj[:status]
				body obj
			end
		end
	end
end
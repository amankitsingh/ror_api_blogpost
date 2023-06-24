module Index
	module V1
		class ArticleApi < Base
			version 'api', using: :path
			format :json
			
			desc 'get the all article details'
			get 'articles' do
				obj = Article.get_all_articles(@user)				
				status obj[:status]
				body obj
			end

			desc "create new article"
			params do
				requires :title, type: String
				requires :description, type: String
				optional :publish, type: Boolean
			end
			post 'article/create' do
				obj = Article.create_article(@user, params)
				status obj[:status]
				body obj
			end

			desc 'get the one article details'
			params do
				requires :title, type: String
			end
			get 'article/:title' do
				obj = Article.get_one_article(@user, params[:title])				
				status obj[:status]
				body obj
			end

			desc 'delete the article'
			params do
				requires :original_article_title, type: String
				requires :new_article_changes, type: Hash
			end
			post 'article/edit' do
				obj = Article.edit_article(@user, params)				
				status obj[:status]
				body obj
			end

			desc 'delete the article'
			params do
				requires :title, type: String
			end
			delete 'article/:title' do
				obj = Article.delete_article(@user, params[:title])				
				status obj[:status]
				body obj
			end
		end
	end
end
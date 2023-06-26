module Index
	module V1
		class ArticleApi < Base
			version 'api', using: :path
			format :json

			desc 'search article'
			params do
				requires :searchtext, type: String
				optional :per, type: Integer
				optional :page, type: Integer
			end
			get 'articles/search' do
				obj = Article.search_article(params)				
				status obj[:status]
				body obj
			end
			
			desc 'get the all article details'
			params do
				optional :id, type: Integer
			end
			get 'articles' do
				obj = Article.get_all_articles(@user,params)
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
			post 'article' do
				obj = Article.get_one_article(@user, params[:title])				
				status obj[:status]
				body obj
			end

			desc "attach cover to article"
			params do
				requires :cover, type: File
				requires :article_title, type: String
			end
			post 'article/cover' do
				puts params.to_s
				obj = Article.attach_cover(@user, params)
				status obj[:status]
				obj.delete(:status)
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

			desc 'rollback the article'
			params do
				requires :article_title, type: String
				requires :step_of_rollback, type: Integer
			end
			post 'article/rollback' do
				obj = Article.rollback_to(@user, params)				
				status obj[:status]
				body obj
			end

		end
	end
end
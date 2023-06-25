class Comment < ApplicationRecord
	
	belongs_to :article
	belongs_to :user

	def self.create_new_comment(user, params)
		article_title = params[:title]
		article_comment_by_user = params[:comment]
		begin
			article = Article.find_by(title: article_title)
			if article.present?
				comment_pre_check = Comment.where(user_id: user.id, article_id: article.id)
				if comment_pre_check.present?
					return {error: 'You have already commented on this article', status: 400}
				end
				comment = Comment.create!(user_id: user.id, value: article_comment_by_user, article_id: article.id, comment_score: 1)
				if comment
					return searialized_response(article, comment)
				else
					{error: 'You cannot comment on this article', status: 400}
				end
			else
				{error: 'Not Article Found', status: 400}
			end
		rescue => e
			message = e.message.to_s
			return {error: message, status: 400}
		end
	end

	def self.view_all_comments(user, params)
		article = 
		if params[:title].present?
			Article.includes(comment: :user).where(title: params[:title]).order("comment.comment_score desc")
		else
			Article.includes(comment: :user).order("comment.comment_score desc")
		end
		if article.present?
			result = {}
			article.each_with_index do |article, index|
				result[article.title] = article.comment.value
			end 
			return result
		else
			{data: 'No comments found', status: 400}
		end
	end
	

	def self.searialized_response(article, comment)
		{
			"title": article.title,
			"comment": comment.value,
			"comment_rating": comment.comment_score
		}
	end
	
end

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
		page = params[:page].present? ? params[:page].to_i : 1
		per_page = params[:per_page].present? ? params[:page].to_i : 10
		article = 
		if params[:title].present?
			Article.includes(:comments, :user).where(title: params[:title]).order("comments.comment_score desc").page(page).per(per_page)
		else
			Article.includes(:comments, :user).order("comments.comment_score desc").page(page).per(per_page)
		end
		if article.present?
			result = {}
			article.each_with_index do |article, index|
				article_comment = {}
				article.comments.each_with_index do |comment, index|
					article_comment["#{comment.user.first_name} #{comment.user.last_name}"] = { comment.value => comment.comment_score } 
				end
				result[article.title] = article_comment
			end 
			return result
		else
			{data: 'No comments found', status: 400}
		end
	end

	# improvement artile rating per user only once
	def self.rate_article(user, params)
		title = params[:title]
		comment_author = params[:comment_author]
		rating = params[:rating] == "good" ? 1 : -1
		begin
			# byebug
			article = Article.joins(:comments, :user).where(title: title).where("users.first_name = ?", comment_author.split(" ").first).take
			if article.present?
				if article.comments.present? and rating == 1 and IndexRedis.get_comment_array_counter(article.id, user.id, rating)
					return {error: 'You have already rated this article', status: 400}
				else
					if rating == -1 and IndexRedis.get_comment_array_counter(article.id, user.id, rating)
						return {error: 'You have already rated this article', status: 400}
					else
						article.comments.last.update(comment_score: article.comments.last.comment_score + rating)
					end
					IndexRedis.insert_comment_array_counter(article.id, user.id, rating)
					IndexRedis.remove_comment_array_counter(article.id, user.id, rating)
					return view_all_comments(article.user, params)
				end
			else
				return {error: 'Not Article Found', status: 400}
			end		
		rescue => e
			message = e.message.to_s
			return {error: message, status: 400}
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

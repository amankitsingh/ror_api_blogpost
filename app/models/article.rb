class Article < ApplicationRecord
	belongs_to :user


	def self.create_article(user, params)
		title = params[:title]
		description = params[:description]
		published = params[:publish]

		begin
			if title.present? and description.present?
				art = [Article.create!(title: title, description: description, published: published, user_id: user.id)]
			end
			author_name = "#{user.first_name} #{user.last_name}"
			return self.create_article_response(art, author_name)
		rescue => e
			if e.message.include? "duplicate"
				message = "Article already exist!!"
			else
				message = e.message.to_s
			end
			return {error: message, status: 400}
		end
	end

	def self.get_one_article(user, title)
		# TODO - join comments
		one_article = user.article.where(title: title).take
		if one_article.present?
			return {
				"Title": one_article.title,
				"Description": one_article.description,
				"Comments": {}
			}
		else
			{error: 'Not Articles Found', status: 400}
		end
	end

	def self.get_all_articles(user)
		articles = user.article
		author_name = "#{user.first_name} #{user.last_name}"
		if articles.present?
			return self.create_article_response(articles, author_name)
		else
			{error: 'Not Articles Found', status: 400}
		end
	end

	def self.create_article_response(articles, author_name)
		article_json = {}
		articles.each_with_index do |article, index|
			article_json[index+1] = {
				"Title": article.title,
				"Description": article.description,
				"Comments": article.comments_count,
				"Published": article.published,
				"Author": author_name,
				"Created on": article.created_at
			}
		end
		return article_json
	end
end

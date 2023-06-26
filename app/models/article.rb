class Article < ApplicationRecord
	include PgSearch::Model
	has_paper_trail

	belongs_to :user
	has_many :comments
	belongs_to :category
  has_many :article_tags
  has_many :tags, through: :article_tags

	has_one_attached :cover

	pg_search_scope :search_articles,
                  against: [:title, :created_at],
									using: {
										tsearch: { prefix: true }
									}

	def self.create_article(user, params)
		params[:published] = params[:publish]
		params.delete(:publish)
		params[:category] = Category.find_by(name: params[:category].downcase)
		params[:user_id] = user.id
		begin
			art = [Article.create!(params)]
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
		one_article = user.article.where(title: title, published: true).take
		if one_article.present?
			return {
				"Title": one_article.title,
				"Description": one_article.description,
				"Comments": one_article.comments.last
			}
		else
			{error: 'Not Articles Found', status: 400}
		end
	end

	def self.get_all_articles(user, params)
		articles =
		if params[:id].present?
			Article.where(user_id: params[:id], published: true)
		else
			Article.all
		end
		author_name = "#{user.first_name} #{user.last_name}"
		if articles.present?
			return self.create_article_response(articles, nil)
		else
			{error: 'Not Articles Found', status: 400}
		end
	end

	def self.create_article_response(articles, author_name)
		article_json = {}
		articles.each_with_index do |article, index|
			author_name = "#{article.user.first_name} #{article.user.last_name}" unless author_name.present?
			article_json[index+1] = {
				"Title": article.title,
				"Description": article.description,
				"Comments": article.comments_count,
				"Published": article.published,
				"Author": author_name.present? ? author_name : "#{article.user.first_name} #{article.user.last_name}",
				"Created on": article.created_at
			}
		end
		return article_json
	end

	def self.edit_article(user, params)
		begin
			original_article = user.article.find_by(title: params[:original_article_title])
			if original_article.present?
				attribute = params[:new_article_changes]
				attribute["edited_at"] = Time.now
				if params[:new_article_changes][:published].present? and params[:new_article_changes][:published]
					attribute["published_at"] = Time.now
				else
					attribute["published_at"] = nil
				end
				status = original_article.update!(attribute)
				author_name = "#{user.first_name} #{user.last_name}"
				if status
					article = [original_article.reload]
					return self.create_article_response(article, author_name)
				end
			else
				{error: 'No Article Found', status: 404}
			end 
		rescue => e
			message = e.message.to_s
			return {error: message, status: 400}
		end
	end

	def self.search_article(params)
		begin
			page = params[:page].present? ? params[:page].to_i : 1
			per_page = params[:per_page].present? ? params[:page].to_i : 10
			searchtext = params[:searchtext]
			article = Article.search_articles(searchtext)
			if article.present?
				return self.paginated_response(article, page, per_page)
			else
				category =  Category.search_category(searchtext).last
				if category.present?
					return self.paginated_response(category.articles, page, per_page)
				else
					tag = Tag.search_tag(searchtext).last
					if tag.present?
						return self.paginated_response(tag.articles, page, per_page)
					else
						{error: 'No Article Found', status: 404}
					end
				end
				{error: 'No Article Found', status: 404}
			end
		rescue => e
			message = e.message.to_s
			return {error: message, status: 400}
		end
	end

	def self.paginated_response(article, page, per_page)
		create_article_response(article.page(page).per(per_page), nil)
	end
	

	def self.delete_article(user, title)
		begin
			status = user.article.find_by(title: title)
			if status.present?
				status.delete
				{message: "Article deleted", status: 202}
			else
				{error: 'No Article Found', status: 404}
			end
		rescue => e
			message = e.message.to_s
			return {error: message, status: 400}
		end
	end

	def self.rollback_to(user, params)
		article_title = params[:article_title]
		step_of_rollback = params[:step_of_rollback]
		begin
			article = Article.find_by(title: article_title)
			if article.present?
				last_version = 
				case step_of_rollback
				when 1
					article.versions.last
				when 2
					article.versions.second
				when 3
					article.versions.third	
				when 4
					article.versions.fourth					
				else
					article.versions.fifth					
				end
				# Rollback the article to the last version
				if last_version.present?
					rolled_back_article = last_version.reify
					if rolled_back_article.save
						self.create_article_response([rolled_back_article], rolled_back_article.user.first_name)
					else
						{error: 'No Article Found', status: 404}
					end
				else
					{error: 'No Article has no versions', status: 404}
				end
			else
				{error: 'No Article Found', status: 404}
			end
		rescue => e
			message = e.message.to_s
			{error: message, status: 404}
		end
  end

	def self.attach_cover(user, params)
		article_title = params[:article_title]
		article_cover = params[:cover]
		begin
			article = Article.where(title: article_title, user_id: user.id)
			if article.present?
				article = article.take
				if article.cover.attached?
					article.cover.purge
					article.cover.attach(io: File.open(params[:cover][:tempfile]), filename: "cover_#{SecureRandom.hex(4)}")
					{message: "Article cover replaced", status: 202}
				else
					article.cover.attach(io: File.open(params[:cover][:tempfile]), filename: "cover_#{SecureRandom.hex(4)}")
					{message: "Article cover attached", status: 202}
				end
			else
				{error: 'No Article Found', status: 404}
			end
		rescue => e
			message = e.message.to_s
			{error: message, status: 404}
		end
	end
	

end

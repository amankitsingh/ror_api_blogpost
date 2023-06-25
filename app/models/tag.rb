class Tag < ApplicationRecord
	belongs_to :category
  has_many :article_tags
  has_many :articles, through: :article_tags


  def self.get_all_tags
    tags = Tag.includes(:articles).all
    result = {}
    tags.each do |tag|
      articles = {}
      tag.articles.each do |article|
        articles["Article Title: #{article.title}"] = {"Summary" => article.description, "Comments count" => article.comments_count}
      end
      result["Tag name: #{tag.name}"] =  articles
    end
    return {data: result, status: 200}
  end

  def self.single_tag_list(name)
    tag = Tag.includes(:articles).find_by(name: name)
    if tag.present?
      return {data: tag.articles, status: 200}
    else
      return {error: "Tag not created", status: 400}
    end
  end
  

  def self.create_tag(user, params)
    begin
      params.transform_values(&:downcase)
      article_name = params[:article_name]
      article = Article.find_by(title: article_name)
      if article.present?
        params.delete(:article_name)
        params[:category] = Category.find_by(name: params[:category].downcase)
        tag = Tag.create(params)
        if tag.present?
          article.tags << tag
        else
          return {error: "Error in creating tag", status: 400}
        end
      end
      return {message: "Tag created and assigned", status: 200}
    rescue => e
      message = e.message.to_s
			return {error: message, status: 400}
    end
  end

  
end

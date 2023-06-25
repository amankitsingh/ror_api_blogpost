class Category < ApplicationRecord
  include PgSearch::Model

	has_many :categorizations
  has_many :articles
  has_many :tags

  pg_search_scope :search_category,
                  against: :name,
									using: {
										tsearch: { prefix: true }
									}
  
  def self.view_all_category
    category = Category.all.pluck(:name)
    {
      data: category,
      status: 200
    }
  end

  def self.get_category_articles(user, category)
    category = Category.includes(:articles).find_by(name: category.downcase)
    if category.present?
      if category.articles.present?
        return {"Article Title": category.articles.pluck(:title), status: 200}
      else
        {error: "No articles found", status: 400}
      end
    else
      {error: "No category found", status: 400}
    end
  end

  def self.create_new_category(user, category)
    begin
      if Category.create(name: category.downcase)
        {error: "Category created"}    
      else
        {error: "No category found", status: 400}
      end
    rescue => e
      {error: "Category cannot be created", status: 400}

    end
  end
  
  
end

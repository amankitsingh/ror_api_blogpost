class Article < ApplicationRecord
  belongs_to :user

  def self.get_all_articles(user)
    articles = user.article
    if articles.present?
      {artciles: articles}
    else
      {error: 'Not Articles Found', status: 400}
    end
  end
end

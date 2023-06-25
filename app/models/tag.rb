class Tag < ApplicationRecord
	belongs_to :category
  has_many :article_tags
  has_many :articles, through: :article_tags
end

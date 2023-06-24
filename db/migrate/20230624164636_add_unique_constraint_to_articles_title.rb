class AddUniqueConstraintToArticlesTitle < ActiveRecord::Migration[7.0]
  def change
    remove_index :articles, name: :index_articles_on_title
    add_index :articles, :title, unique: true
  end
end

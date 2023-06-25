class Addarticleidincommentandremovescommentscoreinarticles < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :comment_score
    add_column :comments, :comment_score, :integer, :default => 0
    rename_column :comments, :author_id, :user_id
  end
end

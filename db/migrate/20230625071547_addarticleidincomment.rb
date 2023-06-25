class Addarticleidincomment < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :article_id, :integer, :default => 0
    add_index :comments, :article_id
  end
end

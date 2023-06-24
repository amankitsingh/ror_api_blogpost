class Renamecolumnauthoridinarticles < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :author_id, :user_id
  end
end

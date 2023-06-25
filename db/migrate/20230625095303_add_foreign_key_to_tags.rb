class AddForeignKeyToTags < ActiveRecord::Migration[7.0]
  def change
    add_reference :tags, :category, foreign_key: true
  end
end
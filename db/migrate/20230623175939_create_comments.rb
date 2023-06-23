class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text "value"
      t.integer "author_id"
      t.index ["author_id"], name: "index_comments_on_author_id"
      t.timestamps
    end
  end
end

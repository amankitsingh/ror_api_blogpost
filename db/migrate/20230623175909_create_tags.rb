class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string "name"
      t.string "category", default: "uncategorized", null: false
      t.index ["name"], name: "index_tags_on_name", unique: true
      t.timestamps
    end
  end
end

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string "name"
      t.timestamps
      t.index ["name"], name: "index_categories_on_name", unique: true
    end
  end
end

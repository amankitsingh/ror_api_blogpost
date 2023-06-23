class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string "title"
      t.text "description"
      t.integer "comment_score", default: 0
      t.integer "comments_count", default: 0, null: false
      t.datetime "edited_at", precision: nil
      t.datetime "last_comment_at", precision: nil, default: "2017-01-01 05:00:00"
      t.boolean "published", default: false
      t.datetime "published_at", precision: nil
      t.boolean "show_comments", default: true
      t.integer "author_id"
      t.timestamps
      t.index ["author_id"], name: "index_articles_on_author_id"
      t.index ["title"], name: "index_articles_on_title"
      t.index ["published"], name: "index_articles_on_published"
    end
  end
end

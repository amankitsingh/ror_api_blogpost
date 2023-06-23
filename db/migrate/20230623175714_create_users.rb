class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.integer "articles_count", default: 0, null: false
      t.integer "comments_count", default: 0, null: false
      t.datetime "confirmation_sent_at", precision: nil
      t.string "confirmation_token"
      t.datetime "confirmed_at", precision: nil
      t.string "encrypted_password", default: "", null: false
      t.datetime "invitation_accepted_at", precision: nil
      t.datetime "invitation_created_at", precision: nil
      t.integer "invitation_limit"
      t.datetime "invitation_sent_at", precision: nil
      t.string "invitation_token"
      t.integer "invitations_count", default: 0
      t.datetime "last_article_at", precision: nil, default: "2017-01-01 05:00:00"
      t.datetime "last_comment_at", precision: nil, default: "2017-01-01 05:00:00"
      t.datetime "latest_article_updated_at", precision: nil
      t.timestamps
      t.index ["email"], name: "index_users_on_email", unique: true
    end
  end
end

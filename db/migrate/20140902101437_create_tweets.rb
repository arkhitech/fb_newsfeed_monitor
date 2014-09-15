class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
    t.string   "tweet_text", index: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_user_id"
    t.string   "tweet_link"
    t.string   "tweeter_name"
      t.timestamps
    end
  end
end

class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|

      t.integer  "user_id", index: true
      t.string   "provider"
      t.string   "uid"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "access_token"
      t.string   "access_secret"
      t.timestamps
    end
  end
end

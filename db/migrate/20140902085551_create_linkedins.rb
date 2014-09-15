class CreateLinkedins < ActiveRecord::Migration
  def change
    create_table :linkedins do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "li_updater_first_name"
    t.string   "li_updater_last_name"
    t.string   "li_updater_headline"
    t.string   "li_update_title", index: true
    t.string   "li_update_shortened_url"
    t.string   "li_user_id", index: true
      t.timestamps
    end
  end
end

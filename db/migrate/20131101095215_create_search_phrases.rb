class CreateSearchPhrases < ActiveRecord::Migration
  def change
    create_table :search_phrases do |t|
      t.string :keyword
      t.string :user_id

      t.timestamps
    end
  end
end

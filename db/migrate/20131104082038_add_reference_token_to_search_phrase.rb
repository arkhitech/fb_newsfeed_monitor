class AddReferenceTokenToSearchPhrase < ActiveRecord::Migration
  def change
    remove_column :search_phrases, :user_id
    add_reference :search_phrases, :user, index: true
  end
end

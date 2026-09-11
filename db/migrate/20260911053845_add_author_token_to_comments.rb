class AddAuthorTokenToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :author_token, :string
  end
end

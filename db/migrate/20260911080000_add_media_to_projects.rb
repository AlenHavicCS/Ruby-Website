class AddMediaToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :image_urls, :text
    add_column :projects, :video_url, :string
  end
end

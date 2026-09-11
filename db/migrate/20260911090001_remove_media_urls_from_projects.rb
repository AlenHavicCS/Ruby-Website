class RemoveMediaUrlsFromProjects < ActiveRecord::Migration[8.1]
  def change
    remove_column :projects, :image_urls, :text
    remove_column :projects, :video_url, :string
  end
end

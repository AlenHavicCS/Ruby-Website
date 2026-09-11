class AddSummaryToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :summary, :text
  end
end

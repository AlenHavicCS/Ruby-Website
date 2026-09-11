class CreateBannedIps < ActiveRecord::Migration[8.1]
  def change
    create_table :banned_ips do |t|
      t.string :ip_address, null: false

      t.timestamps
    end
    add_index :banned_ips, :ip_address, unique: true
  end
end

class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.text :name
      t.timestamp :created_at
      t.timestamp :updated_at
    end
  end
end

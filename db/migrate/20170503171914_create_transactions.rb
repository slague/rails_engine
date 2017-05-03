class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.references :invoice, foreign_key: true
      t.bigint :credit_card_number
      t.string :result
      t.timestamp :created_at
      t.timestamp :updated_at
    end
  end
end

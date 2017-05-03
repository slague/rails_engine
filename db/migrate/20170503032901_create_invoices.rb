class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :status
      t.timestamp :created_at
      t.timestamp :updated_at
    end
  end
end

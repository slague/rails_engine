require 'csv'

class SeedFile
  attr_reader :path, :model

  def initialize(path, model)
    @path = path
    @model = model
  end

  def import
    file_path = Rails.root.to_s + '/db/csv/' + path + '.csv'
    CSV.foreach(file_path, headers: true) do |row|
      # byebug
      row.delete 'credit_card_expiration_date' if row.has_key?('credit_card_expiration_date')
      model.create!(row.to_h)
    end
    puts "#{model.count} #{path.titleize} populated"
  end
end

namespace :seed do
  task seed_data: :environment do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    SeedFile.new('merchants', Merchant).import
    SeedFile.new('items', Item).import
    SeedFile.new('customers', Customer).import
    SeedFile.new('invoices', Invoice).import
    SeedFile.new('invoice_items', InvoiceItem).import
    SeedFile.new('transactions', Transaction).import
  end
end

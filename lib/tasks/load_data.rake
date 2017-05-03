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
      row.delete('id')
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
  end
end

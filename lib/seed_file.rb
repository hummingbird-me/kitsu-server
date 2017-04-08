class SeedFile
  MAX_ID = 2_147_483_647 # Yoinked from Postgres docs

  attr_reader :model, :file

  def initialize(file, model: nil)
    @file = file
    @model = model || File.basename(file, '.*').classify.constantize
  end

  def import!
    data.map do |label, row_data|
      # rubocop:disable Style/ParallelAssignment
      row_data, label = label, nil unless row_data
      # rubocop:enable Style/ParallelAssignment
      row = Row.new(row_data, model, label).import!
      yield (label || row.try(:name) || row[row.primary_key])
    end
  end

  private

  def data
    @data ||= YAML.load_file(file)
  end

  class Row
    attr_reader :data, :model, :label

    def initialize(data, model, label = nil)
      @data = data
      @model = model
      @label = label
    end

    def import!
      instance = model.where(id: id).first_or_initialize
      instance.assign_attributes(data)
      instance.save!
      instance
    end

    def id
      data[model.primary_key] || generated_id
    end

    def generated_id
      Zlib.crc32(label.to_s) % MAX_ID
    end
  end
end

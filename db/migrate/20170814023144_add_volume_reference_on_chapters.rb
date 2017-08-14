class AddVolumeReferenceOnChapters < ActiveRecord::Migration
  def change
    add_reference :chapters, :volume, index: true,
                                      foreign_key: true, null: true, default: nil, required: true
  end
end

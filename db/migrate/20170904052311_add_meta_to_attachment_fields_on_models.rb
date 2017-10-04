class AddMetaToAttachmentFieldsOnModels < ActiveRecord::Migration
  def change
    add_column :anime, :poster_image_meta, :text
    add_column :anime, :cover_image_meta, :text

    add_column :dramas, :poster_image_meta, :text
    add_column :dramas, :cover_image_meta, :text

    add_column :manga, :poster_image_meta, :text
    add_column :manga, :cover_image_meta, :text

    add_column :users, :avatar_meta, :text
    add_column :users, :cover_image_meta, :text

    add_column :groups, :avatar_meta, :text
    add_column :groups, :cover_image_meta, :text

    add_column :episodes, :thumbnail_meta, :text
    add_column :chapters, :thumbnail_meta, :text

    add_column :uploads, :content_meta, :text
  end
end

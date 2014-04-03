class AddAttachmentMediaToEntries < ActiveRecord::Migration
  def self.up
    change_table :entries do |t|
      t.attachment :media
    end
  end

  def self.down
    drop_attached_file :entries, :media
  end
end

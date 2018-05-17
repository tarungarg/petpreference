class CreatePreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :preferences do |t|
      t.float :height
      t.float :weight
      t.string :pet

      t.timestamps
    end
  end
end

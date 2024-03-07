class CreateCages < ActiveRecord::Migration[7.1]
  def change
    create_table :cages do |t|
      t
      t.string :name
      t.boolean :power, default: false, null: false
      t.integer :capacity, default: 0, null: false

      t.timestamps
    end
  end
end

class CreateDinosaurs < ActiveRecord::Migration[7.1]
  def change
    create_table :dinosaurs do |t|
      t.references :cage
      t.string :name
      t.integer :species
      t.integer :dino_type

      t.timestamps
    end
  end
end

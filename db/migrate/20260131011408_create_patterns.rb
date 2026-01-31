class CreatePatterns < ActiveRecord::Migration[8.1]
  def change
    create_table :patterns do |t|
      t.string :regex
      t.text :comment
      t.text :posi_sample
      t.text :nega_sample
      t.integer :hit_count
      t.string :display_name
      t.text :memorandum
      t.integer :category
      t.integer :redos_status

      t.timestamps
    end
  end
end

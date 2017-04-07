class CreateExperts < ActiveRecord::Migration[5.0]
  def change
    create_table :experts do |t|
      t.string :name
      t.decimal :quality_score

      t.timestamps
    end
  end
end

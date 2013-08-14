class CreateFinisheds < ActiveRecord::Migration
  def change
    create_table :finisheds do |t|
      t.string :content
      t.datetime :started_at
      t.datetime :end_at

      t.timestamps
    end
  end
end

class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.integer :frequency
      t.datetime :last_run_at 
      t.text :details
    end

    add_index :jobs, :last_run_at
  end
end

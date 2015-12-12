class CreateSimpleSwitchTables < ActiveRecord::Migration
  def change
    create_table :simple_switch_features do |t|
      t.string :name, null: false, index: true

      t.timestamps null: false
    end

    create_table :simple_switch_environments do |t|
      t.string :name, null: false, index: true

      t.timestamps null: false
    end

    create_table :simple_switch_states do |t|
      t.boolean :status,         default: false
      t.belongs_to :feature,     index: true
      t.belongs_to :environment, index: true

      t.timestamps null: false
    end
  end
end

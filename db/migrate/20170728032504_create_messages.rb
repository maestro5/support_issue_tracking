class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :ticket, index: true, foreign_key: true
      t.text :body, null: false, default: ''
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

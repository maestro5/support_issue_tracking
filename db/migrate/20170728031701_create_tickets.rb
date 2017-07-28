class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :reference_number
      t.references :ticket_status, index: true, foreign_key: true
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.references :department, index: true, foreign_key: true
      t.string :subject, null: false, default: ''
      t.text :question, null: false, default: ''
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateTicketChanges < ActiveRecord::Migration
  def change
    create_table :ticket_changes do |t|
      t.references :ticket, index: true, foreign_key: true, null: false
      t.references :changeable, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
  end
end

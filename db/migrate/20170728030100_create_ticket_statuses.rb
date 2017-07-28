class CreateTicketStatuses < ActiveRecord::Migration
  def change
    create_table :ticket_statuses do |t|
      t.string :name, null: false, default: ''

      t.timestamps null: false
    end
  end
end

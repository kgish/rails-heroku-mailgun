class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :mailgun_id
      t.string :mailgun_status
      t.string :from
      t.string :to
      t.string :subject
      t.text :text

      t.timestamps
    end
  end
end

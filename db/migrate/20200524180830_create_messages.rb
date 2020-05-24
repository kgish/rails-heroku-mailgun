class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :from
      t.string :to
      t.text :subject
      t.text :text

      t.timestamps
    end
  end
end

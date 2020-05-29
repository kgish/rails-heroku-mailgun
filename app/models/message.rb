class Message < ApplicationRecord
  validates_presence_of :from, :to, :subject, :text, :mailgun_id, :mailgun_status
end

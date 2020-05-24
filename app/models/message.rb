class Message < ApplicationRecord
  validates_presence_of :from, :to, :subject, :text
end

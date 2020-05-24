require 'rest-client'

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

# GET /messages
  def index
    @messages = Message.all
    json_response(@messages)
  end

# POST /messages
  def create

    key = ENV['MAILGUN_API_KEY']
    domain = ENV['MAILGUN_API_DOMAIN']
    url = ENV['MAILGUN_API_URL']

    @message = Message.create!(message_params)

    RestClient.post "https://api:#{key}@#{url}/#{domain}/messages",
                    :from => message_params[:from],
                    :to => message_params[:to],
                    :subject => message_params[:subject],
                    :text => message_params[:text]
    json_response(@message, :created)
  end

# GET /messages/:id
  def show
    json_response(@message)
  end

# PUT /messages/:id
  def update
    @message.update(message_params)
    head :no_content
  end

# DELETE /messages/:id
  def destroy
    @message.destroy
    head :no_content
  end

  private

  def message_params
    # whitelist params
    params.permit(:from, :to, :subject, :text)
  end

  def set_message
    @message = Message.find(params[:id])
  end

end

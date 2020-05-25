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

    url = "#{ENV['MAILGUN_API_URL']}/#{ENV['MAILGUN_API_DOMAIN']}/messages"

    payload = {
        from: message_params[:from],
        to: message_params[:to],
        subject: message_params[:subject],
        text: message_params[:text],
    }.to_json

    headers = {
        'Authorization': "Basic #{Base64.strict_encode64('api:' + ENV['MAILGUN_API_KEY'])}",
        'Content-Type': 'application/json; charset=utf-8'
    }
    begin
      response = RestClient::Request.execute(method: :post, url: url, payload: payload, headers: headers)
      body = JSON.parse(response.body)
    rescue => e
      puts "POST #{url} => NOK (#{e.inspect})"
    end

    @message = Message.create!(message_params)
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

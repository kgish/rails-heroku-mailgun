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

    begin
      response = RestClient.post "https://api:#{key}@#{url}/#{domain}/messages",
                                 :from => message_params[:from],
                                 :to => message_params[:to],
                                 :subject => message_params[:subject],
                                 :text => message_params[:text]

      raise 'Invalid response from Mailgun' if response.nil? || response.body.nil? || response.body['id'].nil? || response.body['message'].nil?
      body = JSON.parse(response.body)
      puts "POST '#{url}' => OK result='#{body.inspect}'"
      @message = Message.create!(message_params.merge(mailgun_id: body['id'], mailgun_status: body['message']))
      json_response(@message, :created)
    rescue RestClient::Unauthorized => e
      error = { error: '401 Unauthorized', description: 'Invalid API Key' }
      puts "POST '#{url}' => NOK error='#{error.inspect}'"
      json_response(error, :unauthorized)
    rescue RestClient::NotFound => e
      error = { error: '404 Not Found', description: 'Unknown domain' }
      puts "POST '#{url}' => NOK error='#{error.inspect}'"
      json_response(error, :not_found)
    rescue => e
      error = { error: '422 Unprocessable Entity', description: e.inspect }
      puts "POST '#{url}' => NOK error='#{error.inspect}'"
      json_response(error, :unprocessable_entity)
    end
  end
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

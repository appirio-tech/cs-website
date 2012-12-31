require 'cs_api_message'
require 'message_box'
require 'will_paginate/array'

class MessagesController < ApplicationController

  before_filter :require_login

  def index
    if params[:type].eql?('inbox')
      @messages = CsApi::Message.inbox(current_access_token, current_user.username)
      @message_box = MessageBox.new(current_user.username, :inbox, @messages)
    else
      @messages = CsApi::Message.from(current_access_token, current_user.username)
      @message_box = MessageBox.new(current_user.username, :sent, @messages)
    end
    @messages = @message_box.messages.paginate(:page => params[:page] || 1, :per_page => 20) unless @messages.nil?
  end

  def show
  	@message = CsApi::Message.find(current_access_token, params[:id])
    # update the correct status
    data = {status_from: 'Read'}
    data = {status_to: 'Read'} if current_user.username.eql?(@message['to__r']['name'])
    # mark the message as being read
    results = CsApi::Message.update(current_access_token, params[:id], data)
  end

  def create
    results = CsApi::Message.create(current_access_token, params[:message])
    flash[:notice] = 'Message sent.' if results['success']
    flash[:error] = results['message'] if !results['success']
    redirect_to messages_path
  end  

  def reply
  	results = CsApi::Message.reply(current_access_token, params[:id], params[:message_reply])
    if results['success']
      flash[:notice] = 'Reply sent.'
      redirect_to messages_path
    else
      flash[:error] = results['message']
      redirect_to(:back)
    end
  end

end
class ExceptionReportController < ApplicationController
  
  def show
    @messages = Message.categorised_by_human.all
    @failed_messages = Message.failed_messages.all
  end
  
end
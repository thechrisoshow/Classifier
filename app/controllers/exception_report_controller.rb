class ExceptionReportController < ApplicationController
  
  def show
    @messages = Message.categorised_by_human
    @failed_messages = @messages.select {|m| m.failed_match?}
  end
  
end
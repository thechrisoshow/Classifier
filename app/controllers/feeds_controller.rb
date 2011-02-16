class FeedsController < ApplicationController

  def update
    Feed.update_all!
    
    redirect_to classify_messages_path
  end

end


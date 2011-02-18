class MessagesController < ApplicationController

  def classify
    @classifier = CategoryClassifier.new
    @message = Message.next_unclassified
    @categories = Category.all
    
    respond_to do |format|
      format.html
      format.js { render :js => {:text => @message.text}}
    end
  end
  
  def filter
    if params[:keyword]
      messages = Message.find(:all, :conditions => "text like '%#{params[:keyword]}%' AND text not like '%http%'", :limit => params[:count])

      messages.each {|m| m.machine_categorise!}
      
      @categories = messages.group_by(&:machine_category)
    end
  end

  def bulk_categorize
    params[:message].each do |message_id, message_params|
      message = Message.find(message_id)
      category = Category.find(message_params[:category_id])
      message.human_categorise!(category)      
    end
    redirect_to home_path
  end

  def categorise
    @classifier = CategoryClassifier.new    
    @message = Message.find(params[:id])
    
    if params[:category_id] == "dont_classify"
      @message.destroy
    else
      @category = Category.find(params[:category_id])
      @message.human_categorise!(@category)      
    end
    respond_to do |format|
      format.html {redirect_to classify_messages_path}
      format.js { render :js => {:text => Message.random.text} }
    end
  end

end


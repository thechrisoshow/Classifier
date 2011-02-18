class Message < ActiveRecord::Base
  has_many :word_uses
  has_many :words, :through => :word_uses
  # after_create :create_words_for_message
  # after_create :do_categorisation_if_not_training
  belongs_to :feed, :polymorphic => true
  belongs_to :category
  belongs_to :machine_category, :class_name => "Category"
  
  include HasWords
  
  named_scope :categorised_by_human, :conditions => "category_id is not null"
  named_scope :failed_messages, :conditions => "category_id is not null AND category_id != machine_category_id"
  
  class << self
    def next_unclassified
      message = first(:conditions => "category_id is null AND text not like '%http%'")
    end
    
    def update_all_categories!
      all.each do |message|
        message.machine_categorise!
      end
    end
  end
  
  def failed_match?
    category != (machine_category || derived_category)
  end
  
  def human_categorise!(new_category)
    self.category = new_category
    @@classifier = nil
    self.save!
  end
  
  def machine_categorise!
    self.machine_category ||= derived_category
    self.save!
  end
  
  def exists?
    !!Message.first(:conditions => {:author => self.author, :text => self.text, :location => self.location, :posted_at => self.posted_at, :feed_id => self.feed_id, :feed_type => self.feed_type})
  end
  
  def derived_category
    @classifier ||= CategoryClassifier.new
    
    @derived_category ||= Category.find_by_name @classifier.classify(text)
    # Category.all.sort {|category_1, category_2| self.word_counts.dot_product(category_2.word_counts) <=>  self.word_counts.dot_product(category_1.word_counts)}.first
  end
  
  private
  
  def create_words_for_message
    Word.new_from_message(self)
  end  
  
  def do_categorisation_if_not_training
    if !Setting.training?
      self.machine_categorise!
    end
    return self
  end
  
end
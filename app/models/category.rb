class Category < ActiveRecord::Base
  has_many :word_classifications
  has_many :words, :through => :word_classifications
  
  has_many :messages, :order => "posted_at desc"
  
  named_scope :except_neutral, :conditions => "name != 'Neutral'"
  
  include HasWords
  
  class << self
    def import_all_from_yaml
      YAML.load_file("config/categories.yml").each do |hash|
        self.create(hash) unless first(:conditions => {:name => hash["name"]})
      end
    end
  end
  
end
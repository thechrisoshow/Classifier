class CategoryClassifier
  
  def initialize
    @categories = Category.all
    @bayesian = Classifier::Bayes.new *@categories.collect(&:name)
    @categories.each do |category|
      
      messages = category.messages.collect(&:text)
      messages.each do |message_body|
        @bayesian.send("train_#{category.name.downcase}", message_body)
      end

    end
  end
  
  def classify(message)
    @bayesian.classify(message)
  end
  
end
namespace :import do
  task :feeds => :environment do
    Feed.import_all_from_yaml
  end
  
  task :categories => :environment do
    Category.import_all_from_yaml
  end
  
  task :messages => :environment do
    Feed.update_all!
  end
end

task :recategorise_human => :environment do
  Message.categorised_by_human.all.each {|m| m.machine_categorise! }
end

task :categorise => :environment do
  filter = "HTC"
  raise "Please provide a filter" unless filter

  messages = Message.find(:all, :conditions => "text like '%#{filter}%' AND text not like '%http%' AND machine_category_id IS NULL")
  
  while messages.any? do

    messages.each do |m| 
      message.machine_categorise!
    end
    messages = Message.find(:all, :conditions => "text like '%#{filter}%' AND text not like '%http%' AND machine_category_id IS NULL")
    puts "Categorised another 1000"
  end
    
end

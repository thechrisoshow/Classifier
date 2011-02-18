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
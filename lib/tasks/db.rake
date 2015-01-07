namespace :db do
  desc "YOLO"
  task yolo: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  task yolo2: :environment do
    Rake::Task["db:mongoid:drop"].invoke
    Rake::Task["db:seed"].invoke
  end

end

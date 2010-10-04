namespace :db do
  desc "Add schema information (as comments) to model files"
  task :annotate do
     require File.join(File.dirname(__FILE__), '..', 'annotate_models')
     AnnotateModels.do_annotations
  end
end

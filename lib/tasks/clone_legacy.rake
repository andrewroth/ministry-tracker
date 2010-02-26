namespace :db do
  task :legacy => :environment do
    abcs = ActiveRecord::Base.configurations
    abcs[RAILS_ENV]['database'] = ENV['in']
    abcs['test']['database'] = ENV['out']
    ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
      def supports_migrations?
        false
      end
    end
  end

  namespace :structure do
    namespace :dump do
      task :legacy => [ 'db:legacy', 'db:structure:dump' ] do
      end
    end
  end

  namespace :test do
    namespace :clone_structure do
      task :legacy => [ 'db:legacy', 'db:test:clone_structure' ] do
      end
    end

    namespace :prepare do
      desc "clones structure of the development db -> test db, and ciministry_development -> ciministry_test"
      task :all => :environment do
        abcs = ActiveRecord::Base.configurations
        ENV['in'] = abcs['ciministry_development']['database']
        ENV['out'] = abcs['ciministry_test']['database']
        drop_database(abcs['ciministry_test'])
        create_database(abcs['ciministry_test'])
        Rake::Task["db:test:clone_structure"].invoke
      end
    end
  end
end

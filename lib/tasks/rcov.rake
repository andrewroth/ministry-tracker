 namespace :test do
  desc "Generate code coverage with rcov"
  task :rcov do
    # `rm -Rf coverage`
    # mkdir "coverage"
    rcov = %(rcov --rails -x lib  -o coverage test/**/*_test.rb)
    system rcov
  end
end

require 'ftools'

File.copy File.join(File.dirname(__FILE__), 'mappings.yml'), Rails.root.join('config')
File.copy File.join(File.dirname(__FILE__), 'deploy.rb'), Rails.root.join('config')

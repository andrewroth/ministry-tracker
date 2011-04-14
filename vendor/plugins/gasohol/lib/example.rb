# Creates an instance of the search and does a simple one

require 'gasohol'

SEARCH = Gasohol::Search.new({:url => 'http://127.0.0.1/search', :client => 'my_frontend', :collection => 'my_collection'})
puts SEARCH.search('pizza').inspect
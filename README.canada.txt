To Setup

rake db tasks seem to be hardcodeded to database.yml so...
1. rake canada:reset
- Creates backup of database.yml
- Copies database.emu.yml to database.yml
- Runs rake db:migrate:reset
- Restores original database.yml

NOTE: This step assumes you have an original copy of the hrdb database called the name that is under 'ciministry_development' in the database.emu.yml file.

== Extras ==
To load data about who is on what campus do:
rake canada:import
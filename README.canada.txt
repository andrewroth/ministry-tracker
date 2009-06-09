To Setup

1. rake db:create
2. rake db:migrate

rake db tasks seem to be hardcodeded to database.yml so...
2. rake canada:reset
- Creates backup of database.yml
- Copies database.emu.yml to database.yml
- Runs rake db:migrate:reset
- Restores original database.yml

== Extras ==
To load data about who is on what campus do:
rake canada:import
== Setup ==

rake db tasks seem to be hardcodeded to database.yml so...

1. rake canada:reset
- Creates backup of database.yml
- Copies database.emu.yml to database.yml
- Runs rake db:migrate:reset
- Restores original database.yml

NOTE: This step assumes you have an original copy of the hrdb database called the name that is under 'ciministry_development' in the database.emu.yml file.

== Development ==
Both 'ciministry_development' and 'development' databases will be used when developing as we are in the process of transitioning over to the ciministry database schema for the canadian version of ministry tracker.

For example, if you ruby script/console,

	>> Province.table_name
	=> "emu_development.provinces"
	>> Person.table_name
	=> "ciministry.cim_hrdb_person"


== Extras ==
To load data about who is on what campus do:
rake canada:import
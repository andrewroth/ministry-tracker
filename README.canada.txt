== Setup ==

rake db tasks seem to be hardcodeded to database.yml so...

1. rake canada:reset
- Creates backup of database.yml
- Copies database.emu.yml to database.yml
- Runs rake db:migrate:reset
- Restores original database.yml

NOTE: This step assumes you have an original copy of the hrdb database called the name that is under 'ciministry_development' in the database.emu.yml file.  You do not need to change the name of your database to match. You can just change the name of the database in database.emu.yml to match.

NOTE: You may get a rake mysql error:

'Mysql::Error: Unknown column 'c.province_id' in 'on clause': selectc.campus_shortDesc, c.campus_id from cim_hrdb_campus c left joincim_hrdb_province p on c.province_id = p.province_id left join cim_hrdb_countryct on ct.country_id = p.country_id where c...'

** Contact Andrew about this. **  I believe the dump for loop 09 is buggered.


== Development ==
Both 'ciministry_development' and 'development' databases are used when developing.

//  FIXME Province.table_name should not be used as an example
For example, if you ruby script/console,

	>> Province.table_name
	=> "emu_development.provinces"
	>> Person.table_name
	=> "ciministry.cim_hrdb_person"


== Extras ==
To load data about who is on what campus do:
rake canada:import
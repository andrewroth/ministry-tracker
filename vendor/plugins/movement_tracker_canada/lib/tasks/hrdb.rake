namespace :hrdb do
  namespace :staff do
    task :cleanup => :environment do
      duplicates = {}
      Staff.all.each do |staff|
        duplicates[staff.person_id] ||= [ ]
        duplicates[staff.person_id] << staff.id
      end

      duplicates.each_pair do |person_id, staffs|
        if staffs.length > 1
          p = Person.find(person_id)
          puts "Person #{person_id} #{p.full_name}"
          puts "keep " + Staff.find(staffs.first).inspect
          Staff.find(staffs[1..staffs.length]).each do |staff|
            puts "destroy " + staff.inspect
            staff.destroy
          end
        end
      end
    end
  end
end


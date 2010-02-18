Factory.define :correspondence_1, :class => Correspondence do |c|
   c.id '1'
   c.correspondence_type_id '1'
   c.person_id '1'
   c.receipt '12345'
   c.state '10'
   c.visited '2009-04-07'
   c.completed '2009-04-07'
   c.overdue_at '2009-04-07'
   c.expire_at '2009-04-07'
   c.token_params '{ campus: { type: record, class: Campus, id: 2 }, testData: { type: datastore, contents: { second: { id: 2, who: fooe}, first: { id: 1, who: somethig } }, class: Hash }, sender: { type: record, class: Person, id: 4} }'
   c.created_at '2009-04-07 09:38:44'
   c.updated_at '2009-04-07 09:38:44'
end

Factory.define :correspondence_2, :class => Correspondence do |c|
   c.id '2'
   c.correspondence_type_id '1'
   c.person_id '1'
   c.receipt '54321'
   c.state '10'
   c.visited '2009-04-07'
   c.completed '2009-04-07'
   c.overdue_at '2009-04-07'
   c.expire_at '2009-04-07'
   c.token_params '{ campus: { type: record, class: Campus, id: 2 }, testData: { type: datastore, contents: { second: { id: 2, who: fooe}, first: { id: 1, who: somethig } }, class: Hash }, sender: { type: record, class: Person, id: 4} }'
   c.created_at '2009-04-07 09:38:44'
   c.updated_at '2009-04-07 09:38:44'
end

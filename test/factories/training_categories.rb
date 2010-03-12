Factory.define :trainingcategory_1, :class => TrainingCategory, :singleton => true, :singleton => true do |t|
  t.id '1'
  t.name 'Four Laws'
  t.position '1'
  t.ministry_id '1'
end

Factory.define :trainingcategory_2, :class => TrainingCategory, :singleton => true, :singleton => true do |t|
  t.id '2'
  t.position '2'
  t.name 'Empty Category'
  t.ministry_id '1'
end

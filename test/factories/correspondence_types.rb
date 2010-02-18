Factory.define :correspondencetype_1, :class => CorrespondenceType do |c|
   c.id '1'
   c.name 'PleaseVerify'
   c.overdue_lifespan '4'
   c.expiry_lifespan '35'
   c.redirect_params '{ action: show, controller: people }'
   c.redirect_target_id_type 'sender'
end


Factory.define :group_invitation_1, :class => GroupInvitation, :singleton => true do |g|
  g.id '1'
  g.group_id '1'
  g.recipient_email 'somedude@email.com'
  g.recipient_person_id nil
  g.sender_person_id '50000'
  g.accepted nil
  g.login_code_id nil
end

Factory.define :group_invitation_2, :class => GroupInvitation, :singleton => true do |g|
  g.id '1'
  g.group_id '1'
  g.recipient_email 'sue@student.org'
  g.recipient_person_id '2000'
  g.sender_person_id '50000'
  g.accepted nil
  g.login_code_id nil
end



# Roles like Honourary member, approval pending, registration incomplete
class OtherRole < MinistryRole
  load_mappings
  include Common::Core::OtherRole
end

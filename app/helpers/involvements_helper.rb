module InvolvementsHelper
  def involvement
    instance_variable_get("@#{@singular}_involvement")
  end
end

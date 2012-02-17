# Let me ask a hash with only one member what its key or value is
class Hash
  def key
    self.keys.first if self.length == 1
  end
  
  def value
    self.values.first if self.length == 1
  end
end

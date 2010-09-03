class Hash
  # Ruby 1.8.6 doesn't define a Hash specific hash method
  def hash
    h = 0
    each do |key, value|
      h ^= key.hash ^ value.hash
    end
    h
  end unless {}.hash == {}.hash

  # Ruby 1.8.6 doesn't define a Hash specific eql? method.
  def eql?(other)
    other.is_a?(Hash) &&
      size == other.size &&
      all? do |key, value|
        other.fetch(key){return false}.eql?(value)
      end
  end unless {}.eql?({})
end

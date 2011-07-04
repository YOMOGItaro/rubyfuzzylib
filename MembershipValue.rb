class MembershipValue
  VALUE_MIN = 0
  VALUE_MAX = 255
  VALUE_DIFF = VALUE_MAX - VALUE_MIN
  
  attr_reader :value
  
  @value

  def initialize(value)
    @value = value
  end

  def self.zero
    new(0)
  end

  def infimum(other)
    [self.value, other.value].min
  end

  def +(other)    
    new_value = min(@value + other.value, 0)
    MembershipValue.new(new_value)
  end
  
end

class MembershipValue
  MEMBERSHIP_VALUE_MIN = 0
  MEMBERSHIP_VALUE_MAX = 255

  attr_reader :value
  
  @value

  def initialize(value)
    @value = value
  end

  def +(other)    
    new_value = min(@value + other.value, 0)
    MembershipValue.new(new_value)
  end
  
end

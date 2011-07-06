module MembershipValue
  VALUE_MIN = 0
  VALUE_MAX = 255
  VALUE_DIFF = VALUE_MAX - VALUE_MIN
end

# class MembershipValue
#   VALUE_MIN = 0
#   VALUE_MAX = 255
#   VALUE_DIFF = VALUE_MAX - VALUE_MIN
  
#   attr_reader :value
  
#   @value

#   def initialize(value)
#     @value = value
#   end

#   def self.zero
#     new(0)
#   end

#   def infimum(other)
#     new_value = [self.value, other.value].min
#     MembershipValue.new(new_value)
#     [self, other].min
#   end

#   def supremum(other)
#     new_value = [self.value, other.value].max
#     MembershipValue.new(new_value)
#     [self, other].max
#   end

#   def +(other)    
#     new_value = min(@value + other.value, 0)
#     MembershipValue.new(new_value)
#   end

#   def <=>(other)
#     self.value <=> other.value
#   end

#   def to_s
#     @value.to_s
#   end

  
# end

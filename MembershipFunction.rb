

class MembershipFunction
  @name
  
  def self.zero
    MembershipFunctionZero.new
  end

  def self.valued_zero
    MembershipFunctionValued.zero
  end

  def centroid
    waited_area / area
  end

  def or(rhs)
    ret = MembershipFunction.valued_zero

    PARTITIONED_ELEMENT_NUMBER.each(0){ |iter|
      ret.set_membership_value(iter, min(self.call(x), rhs))
    }

    ret
  end

  def or!(rhs)
    self = self.or(rhs)
  end
end

class MembershipFunctionValued < MembershipFunction
  @values

  def initialize
    @values = Array.new(PARTITIONED_ELEMENT_NUMBER, 0)
  end

  def self.zero
    @values = Array.new(PARTITIONED_ELEMENT_NUMBER, 0)
    self
  end

  def set_at
  end
end

class MembershipFunctionZero < MembershipFunction
  def initialize
    # NOTHING TO DO
  end
  
  def call(x)
    0
  end

  def area
    0
  end

  def waited_area
    0
  end
end

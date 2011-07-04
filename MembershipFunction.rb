

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

  def to_membership_function_valued
    ret = MembershipFunctionValued.new
    
    PARTITIONED_ELEMENT_NUMBER.each(0){ |iter|
      ret.set_at(iter, self.call(iter))
    }
    
    ret
  end
end

class MembershipFunctionValued < MembershipFunction
  attr_reader :values
  
  @values

  def initialize(values)
    @values = values
  end

  def self.zero
    new(Array.new(PARTITIONED_ELEMENT_NUMBER, MembershipValue.zero))
  end

  def set_at(index, value)
    @values[index] = value
  end

  def infimum(other)
    ret = MembershipFunctionValued.zero

    ret.each_index{ |iter|
      new_value = self.values[iter].infimum(other.values[iter])
      ret.set_at(iter, new_value)
    }

    ret
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

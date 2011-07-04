require 'MembershipValue.rb'

class MembershipFunction
  PARTITIONED_ELEMENT_NUMBER = 256

  @name
  @range
  
  
  def initialize(name, range)
    @name = name
    @range = range
  end
  
  def self.zero
    MembershipFunctionZero.new
  end

  def self.valued_zero
    MembershipFunctionValued.zero
  end

  def centroid
    waited_area / area
  end

  def infimum(other)
    self_valued = self.to_membership_function_valued
    other_valued = other.to_membership_function_valued
    ret = MembershipFunctionValued.zero

    ret.values.each_index{ |idx|
      ret.values[idx] = self_valued.values[idx].infimum(other_valued.values[idx])
    }
  end
 
  def or(rhs)
    ret = MembershipFunction.valued_zero

    PARTITIONED_ELEMENT_NUMBER.each(0){ |iter|
      ret.set_membership_value(iter, min(self.call(x), rhs))
    }

    ret
  end

  def to_membership_function_valued
    ret = MembershipFunctionValued.zero
    
    PARTITIONED_ELEMENT_NUMBER.times{ |iter|
      ret.set_at(iter, self.call(iter))
    }
    
    ret
  end
end

class MembershipFunctionTrapezoid < MembershipFunction
  @left_bottom
  @left_top
  @right_top
  @right_bottom

  def initialize(left_bottom, left_top, right_top, right_bottom)
    @left_bottom = left_bottom
    @left_top = left_top
    @right_top = right_top
    @right_bottom = right_bottom
  end

  def call(x)
    MembershipValue.new(call_in(x))
  end

  def call_in(x)
    if x < @left_bottom
      MembershipValue::VALUE_MIN
    elsif x < @left_top
      MembershipValue::VALUE_MIN + MembershipValue::VALUE_DIFF  * (x - @left_bottom) / (@left_top - @left_bottom)
    elsif x < @right_top
      MembershipValue::VALUE_MAX
    elsif x < @right_bottom
      MembershipValue::VALUE_MIN + MembershipValue::VALUE_DIFF * (@right_bottom - x) / (@right_bottom - @right_top)
    else
      MembershipValue::VALUE_MIN
    end
  end
end

class MembershipFunctionValued < MembershipFunction
  attr_reader :values
  
  @values

  def initialize(name, range, values)
    @name = name
    @range = range
    @values = values
  end

  def self.from_yield
    values = Array.new(PARTITIONED_ELEMENT_NUMBER, MembershipValue.zero)
    values.each_index{ |idx|
      values[idx] = yield idx
    }
  end

  def self.zero
    new("hello", 0..255, Array.new(PARTITIONED_ELEMENT_NUMBER, MembershipValue.zero))
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



mft1 = MembershipFunctionTrapezoid.new(30,100,100,200)
mft2 = MembershipFunctionTrapezoid.new(1,50,50,100)
p mft1.infimum(mft2)

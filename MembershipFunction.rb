require 'MembershipValue.rb'

class MembershipFunction
  PARTITIONED_ELEMENT_NUMBER = 64

  @name
  @min_arg
  @max_arg
  
  
  def initialize(
                 name,
                 min_arg = MembershipValue::VALUE_MIN,
                 max_arg = MembershipValue::VALUE_MAX)
    @name = name
    @min_arg = min_arg
    @max_arg = max_arg
  end
  
  def self.zero
    MembershipFunctionZero.new
  end

  def self.valued_zero
    MembershipFunctionValued.zero
  end

  def to_s
    ret = String.new
    PARTITIONED_ELEMENT_NUMBER.times{ |idx|
      ret += idx.to_s + " : " + call(idx).to_s + "\n"
    }
    return ret
  end

  def label
    @name
  end
  
  def partition_range
    (@max_arg - @min_arg).to_f / MembershipFunction::PARTITIONED_ELEMENT_NUMBER
  end

  def to_idx_from_arg(x)
    ((x - @min_arg) / partition_range).to_i
  end

  def at(x)
    call(to_idx_from_arg(x))
  end
  
  def waited_area
    ret = 0.0

    PARTITIONED_ELEMENT_NUMBER.times{ |idx|
      ret += call(idx).value * idx
    }

    return ret
  end

  def area
    ret = 0.0

    PARTITIONED_ELEMENT_NUMBER.times{ |idx|
      ret += call(idx).value
    }

    return ret
  end

  def centroid
    if area == 0
      0.0
    else
      waited_area / area
    end
  end

  def infimum(other)
    #self_valued = self.to_membership_function_valued
    #other_valued = other.to_membership_function_valued
    ret = MembershipFunctionValued.zero

    ret.values.each_index{ |idx|
      #ret.values[idx] = self_valued.values[idx].infimum(other_valued.values[idx])
      ret.values[idx] = self.call(idx).infimum(other.call(idx))
    }

    return ret
  end

  def supremum(other)
    #self_valued = self.to_membership_function_valued
    #other_valued = other.to_membership_function_valued
    ret = MembershipFunctionValued.zero

    ret.values.each_index{ |idx|
      ret.values[idx] = self.call(idx).supremum(other.call(idx))
    }

    return ret
  end

  def alpha_cut(alpha)
    ret = MembershipFunctionValued.zero
        PARTITIONED_ELEMENT_NUMBER.times{ |iter|
      ret.set_at(iter, [self.call(iter), alpha].min)
    }

    return ret
  end
 
  def to_membership_function_valued
    ret = MembershipFunctionValued.zero
    
    PARTITIONED_ELEMENT_NUMBER.times{ |iter|
      ret.set_at(iter, self.call(iter))
    }
    
    return ret
  end
end

class MembershipFunctionTrapezoid < MembershipFunction
  @left_bottom
  @left_top
  @right_top
  @right_bottom

  def initialize(left_bottom,
                 left_top,
                 right_top,
                 right_bottom,
                 name = "",
                 min_arg = MembershipValue::VALUE_MIN,
                 max_arg = MembershipValue::VALUE_MAX)
    super(name, min_arg, max_arg)
    
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

  def initialize(values,
                 name = "",
                 min_arg = MembershipValue::VALUE_MIN,
                 max_arg = MembershipValue::VALUE_MAX)
    super(name, min_arg, max_arg)

    @name = name
    @values = values
  end

  def self.from_yield
    values = Array.new(PARTITIONED_ELEMENT_NUMBER, MembershipValue.zero)
    values.each_index{ |idx|
      values[idx] = yield idx
    }
  end

  def self.zero
    new(Array.new(PARTITIONED_ELEMENT_NUMBER, MembershipValue.zero))
  end

  def set_at(index, value)
    @values[index] = value
  end

  def infimum(other)
    ret = MembershipFunctionValued.zero

    ret.values.each_index{ |iter|
      new_value = self.call(iter).infimum(other.call(iter))
      ret.set_at(iter, new_value)
    }

    ret
  end

  def call(x)
    @values[x]
  end
end


class MembershipFunctionZero < MembershipFunction
  def initialize
    # NOTHING TO DO
  end
  
  def call(x)
    MembershipValue.zero
  end

  def area
    0
  end

  def waited_area
    0
  end
end


if __FILE__ == $0
  mft1 = MembershipFunctionTrapezoid.new(30,100,100,200,"",2.0,20.5)
  mft2 = MembershipFunctionTrapezoid.new(1,50,50,100)

  print mft1.to_membership_function_valued
  p mft1.at(10)
  
  #p mft1.infimum(mft2)
end

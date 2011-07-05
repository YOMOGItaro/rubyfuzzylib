require 'MembershipFunction.rb'


class FuzzySet

  @name
  @membership_functions
  

  def initialize(name, membership_functions)
    @name = name
    @membership_functions = membership_functions
  end

  def each
    @membership_functions.each{ |k,mf|
      yield mf
    }
  end

  def label
    @name
  end

  def to_gnuplot_data
    ret = ""

    @membership_functions.each{ |k, mf|
      ret += k + ' '
    }
    ret += "\n"

    
    MembershipFunction::PARTITIONED_ELEMENT_NUMBER.times{ |iter|
      self.each{ |mf|
        ret += mf.call(iter).to_s + ' '
      }
      ret += "\n"
    }

    return ret
  end
  
  def reference(label)
    @membership_functions[label]
  end
end



if __FILE__ == $0

  mfs = Hash.new
  mfs["low"] = MembershipFunctionTrapezoid.new(  1, 50, 50,100, "low")
  mfs["mid"] = MembershipFunctionTrapezoid.new( 50,100,100,150, "mid")
  mfs["top"] = MembershipFunctionTrapezoid.new(100,150,150,200, "top")

  fs = FuzzySet.new("baribari", mfs)
#  p fs.reference("low")
  print fs.to_gnuplot_data
end

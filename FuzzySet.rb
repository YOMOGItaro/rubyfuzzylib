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

  def reference(label)
    @membership_functions[label]
  end
end



if __FILE__ == $0
  require 'MembershipFunction.rb'

  mfs = Hash.new
  mfs["low"] = MembershipFunctionTrapezoid.new(  1, 50, 50,100)
  mfs["mid"] = MembershipFunctionTrapezoid.new( 50,100,100,150)
  mfs["top"] = MembershipFunctionTrapezoid.new(100,150,150,200)

  fs = FuzzySet.new("baribari", mfs)
  p fs.reference("low")
end


class FuzzySet

  @name
  @membership_functions
  
  def initialize(name, membership_functions)
    @name = name
    @membership_functions = membership_functions
  end

  def each
    @membership_functions.each{ |mf|
      yield mf
    }
  end

  def reference(label)
    @membership_functions[label]
  end
end

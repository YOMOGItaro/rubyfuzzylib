# -*- coding: undecided -*-
=begin rdoc
  2011/07/04
  YOMOGI
  
  
=end


class FuzzyInferenceUnit
  
  @antecedent_fuzzy_set1
  @antecedent_fuzzy_set2
  @fuzzy_conditional_proposition
  @consequent_fuzzy_set

  def initialize(
                 antecedent_fuzzy_set1,
                 antecedent_fuzzy_set2,
                 fuzzy_conditional_proposition,
                 consequent_fuzzy_set
                 )
    @antecedent_fuzzy_set1 = antecedent_fuzzy_set1
    @antecedent_fuzzy_set2 = antecedent_fuzzy_set2
    @fuzzy_conditional_proposition = fuzzy_conditional_proposition
    @consequent_fuzzy_set = consequent_fuzzy_set
  end

  def call(x1, x2)
    omf = output_membership_function(x1, x2)
    omf.centroid # TODO 0 div
  end

  def output_membership_function(x1, x2)
    ret = MembershipFunction.valued_zero
    
    each_membership_function_couple{ |amf1, amf2, cmf| 
      alpha = [amf1.call(x1), amf2.call(x2)].min
      ret = ret.supremum(cmf.alpha_cut(alpha))
    }

    ret
  end

  def each_membership_function_couple
    @antecedent_fuzzy_set1.each{ |amf1|
      @antecedent_fuzzy_set2.each{ |amf2|
        cmf = consequent_membership_function_from_labels(amf1.label, amf2.label)
        yield amf1, amf2, cmf
      }
    }
  end

  def consequent_membership_function_from_labels(label1, label2)
    consequent_label = @fuzzy_conditional_proposition.reference(label1, label2)
    @consequent_fuzzy_set.reference(consequent_label)
  end

  def consequent_label(label1, label2)
    @fuzzy_conditional_proposition.reference(label1, label2)
  end

  def consequent_membership_function(label1, label2)
    @consequent_fuzzy_set.at(consequent_label(label1, label2))
  end
end



if __FILE__ == $0
  require 'FuzzySet.rb'
  require 'FuzzyConditionalProposition.rb'
  require 'MembershipFunction.rb'

  ct = {
    "low" => { "low" => "low", "mid" => "low", "top" => "mid"},
    "mid" => { "low" => "low", "mid" => "mid", "top" => "mid"},
    "top" => { "low" => "mid", "mid" => "top", "top" => "top"}
  }
  fcp = FuzzyConditionalProposition.new(ct)

  mfs1 = { 
  "low" => MembershipFunctionTrapezoid.new(  1, 50, 50,100, "low"),
  "mid" => MembershipFunctionTrapezoid.new( 50,100,100,150, "mid"),
  "top" => MembershipFunctionTrapezoid.new(100,150,150,200, "top")
  }
  fs1 = FuzzySet.new("hoge", mfs1)


  mfs2 = {
  "low" => MembershipFunctionTrapezoid.new(  1, 50, 50,100, "low"),
  "mid" => MembershipFunctionTrapezoid.new( 50,100,100,150, "mid"),
  "top" => MembershipFunctionTrapezoid.new(100,150,150,200, "top")
  }
  fs2 = FuzzySet.new("pero", mfs2)


  cmfs = {
  "low" => MembershipFunctionTrapezoid.new(  1, 50, 50,100, "low"),
  "mid" => MembershipFunctionTrapezoid.new( 50,100,100,150, "mid"),
  "top" => MembershipFunctionTrapezoid.new(100,150,150,200, "top")
  }
  cfs = FuzzySet.new("ushiro", cmfs)

  fiu = FuzzyInferenceUnit.new(fs1, fs2, fcp, cfs)
  p fiu.call(50, 100)
end

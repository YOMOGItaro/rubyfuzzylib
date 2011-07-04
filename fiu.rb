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
    ret = MembershipFunction.zero
    
    each_membership_function_couple{ |amf1, amf2, cmf| 
      alpha = min(amf1.call(x1), amf2.call(x2))
      ret.or!(cmf.alpha_cut(alpha))
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

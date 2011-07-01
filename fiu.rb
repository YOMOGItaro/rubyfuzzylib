class FuzzyInferenceUnit
  PARTITIONED_ELEMENT_NUMBER = 256
  
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
    
    @fuzzy_conditional_proposition.each{ |amf1, amf2, cmf| 
      alpha = min(amf1.call(x1), amf2.call(x2))
      ret.or!(cmf.alpha_cut(alpha))
    }

    ret
  end

  def consequent_label(label1, label2)
    @fuzzy_conditional_proposition.reference(label1, label2)
  end

  def consequent_membership_function(label1, label2)
    @consequent_fuzzy_set.at(consequent_label(label1, label2))
  end
end

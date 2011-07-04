class FuzzyConditionalProposition
  @correspondence_table
  
  def initialize(correspondence_table)
    @correspondence_table = correspondence_table
  end

  def reference(label1, label2)
    @correspondence_table[label1][label2]
  end
end

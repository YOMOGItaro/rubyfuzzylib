class FuzzyConditionalProposition
  @correspondence_table
  
  def initialize(correspondence_table)
    @correspondence_table = correspondence_table
  end

  def reference(label1, label2)
    @correspondence_table[label1][label2]
  end
end



if __FILE__ == $0
  ct = Hash.new
  ct = {
    "low" => { "low" => "low", "mid" => "low", "top" => "mid"},
    "mid" => { "low" => "low", "mid" => "mid", "top" => "mid"},
    "top" => { "low" => "mid", "mid" => "top", "top" => "top"}
  }
  
  fcp = FuzzyConditionalProposition.new(ct)
  
end

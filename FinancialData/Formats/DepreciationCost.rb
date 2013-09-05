require_relative 'FommatterModule'

class DepreciationCost
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :DepreciationAndAmortizationOpeCF)
    ])
  end

end
require_relative 'Formats'

class DepreciationCost < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :DepreciationAndAmortizationOpeCF)
    ])
  end

end
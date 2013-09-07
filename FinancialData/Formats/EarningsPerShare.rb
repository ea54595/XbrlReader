require_relative 'Formats'

class EarningsPerShare < Formats
  
  def self.calculate(result)
    
    value = (get_item_form_result(result, :NetIncomePerShare) ||
      get_item_form_result(result, :NetIncomePerShareUS) ||
      get_item_form_result(result, :BasicEarningsPerShareIFRS)
    )
    check_and_merge([
      value 
    ])
  end

end
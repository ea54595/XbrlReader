require_relative 'FommatterModule'

class EarningsPerShare
  include FommatterModule
  
  def self.calcuate(result)
    
    value = (get_item_form_result(result, :NetIncomePerShare) ||
      get_item_form_result(result, :NetIncomePerShareUS) ||
      get_item_form_result(result, :BasicEarningsPerShareIFRS)
    )
    check_and_merge([
    ])
      value 
    ])
  end

end
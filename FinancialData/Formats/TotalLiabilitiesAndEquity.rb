require_relative 'FommatterModule'

class TotalLiabilitiesAndEquity  
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :Assets)
    ])
  end
end
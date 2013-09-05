require_relative 'FommatterModule'

class GrossProfit
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :GrossProfit)
    ])
  end
end
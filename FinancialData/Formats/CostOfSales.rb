require_relative 'FommatterModule'

class CostOfSales
  include FommatterModule
  
  def self.calcuate(result)
    value = get_item_form_result(result, :CostOfSales) || get_item_form_result(result, :OperatingExpenses2)

    check_and_merge([
      value
    ])
  end

end
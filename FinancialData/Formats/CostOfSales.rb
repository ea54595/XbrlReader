require_relative 'Formats'

class CostOfSales < Formats
  
  def self.calculate(result)
    value = get_item_form_result(result, :CostOfSales) || get_item_form_result(result, :OperatingExpenses2)

    check_and_merge([
      value
    ])
  end

end
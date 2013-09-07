require_relative 'Formats'

class CurrentNetIncome < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :NetIncomeNA)
    ])
  end

end
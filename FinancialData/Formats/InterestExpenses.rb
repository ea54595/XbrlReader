require_relative 'Formats'

class InterestExpenses < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :InterestExpensesNOE)
    ])
  end

end
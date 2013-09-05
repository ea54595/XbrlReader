require_relative 'FommatterModule'

class InterestExpenses
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :InterestExpensesNOE)
    ])
  end

end
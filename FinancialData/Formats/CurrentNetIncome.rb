require_relative 'FommatterModule'

class CurrentNetIncome
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :NetIncomeNA)
    ])
  end

end
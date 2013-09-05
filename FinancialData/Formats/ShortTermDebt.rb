require_relative 'FommatterModule'

class ShortTermDebt
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :ShortTermLoansPayable),
      get_item_form_result(result, :CurrentPortionOfLongTermLoansPayable),
      get_item_form_result(result, :CurrentPortionOfBonds),
    ])
  end
end
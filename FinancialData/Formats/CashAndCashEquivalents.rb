require_relative 'FommatterModule'

class CashAndCashEquivalents
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :CashAndDeposits)
    ])
  end

end
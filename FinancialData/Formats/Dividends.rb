require_relative 'FommatterModule'

class Dividends
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :CashDividendsPaidFinCF)
    ])
  end

end
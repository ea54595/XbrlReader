require_relative 'Formats'

class CashAndCashEquivalents < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :CashAndDeposits)
    ])
  end

end
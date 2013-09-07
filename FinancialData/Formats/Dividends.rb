require_relative 'Formats'

class Dividends < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :CashDividendsPaidFinCF)
    ])
  end

end
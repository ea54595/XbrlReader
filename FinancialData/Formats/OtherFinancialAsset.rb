require_relative 'Formats'

class OtherFinancialAsset < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :ShortTermInvestmentSecurities),
      get_item_form_result(result, :OperationalInvestmentSecuritiesCA)
    ])
  end
end
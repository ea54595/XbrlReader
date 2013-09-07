require_relative 'Formats'

class PurchasesOfStockForTreasury < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :PurchaseOfTreasuryStockTS)
    ])
  end

end
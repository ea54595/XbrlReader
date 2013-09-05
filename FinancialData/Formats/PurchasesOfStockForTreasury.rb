require_relative 'FommatterModule'

class PurchasesOfStockForTreasury
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :PurchaseOfTreasuryStockTS)
    ])
  end

end
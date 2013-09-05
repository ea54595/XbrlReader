require_relative 'FommatterModule'

class CapitalExpenditure
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :PurchaseOfPropertyPlantAndEquipmentInvCF),
      get_item_form_result(result, :PurchaseOfIntangibleAssetsInvCF),
      get_item_form_result(result, :PurchaseOfPropertyPlantAndEquipmentAndIntangibleAssetsInvCF)
    ])
  end

end
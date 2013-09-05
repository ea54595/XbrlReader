require_relative 'FommatterModule'

class LongTermDebt
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :BondsPayable),
      get_item_form_result(result, :ConvertibleBondTypeBondsWithSubscriptionRightsToShares),
      get_item_form_result(result, :LongTermLoansPayable)
    ])
  end  
end
require_relative 'FommatterModule'

class NetCashProvidedByOperatingActivities
  include FommatterModule
    value = (
      get_item_form_result(result, :NetCashProvidedByUsedInOperatingActivities) ||
      get_item_form_result(result, :CashFlowsFromOperatingActivitiesUS) ||
      get_item_form_result(result, :CashFlowsFromOperatingActivitiesIFRS)
    )
      
  def self.calcuate(result)
    check_and_merge([
      value  
    ])
  end

end
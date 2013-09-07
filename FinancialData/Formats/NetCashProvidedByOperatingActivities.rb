require_relative 'Formats'

class NetCashProvidedByOperatingActivities < Formats
    
  def self.calculate(result)
    value = (
      get_item_form_result(result, :NetCashProvidedByUsedInOperatingActivities) ||
      get_item_form_result(result, :CashFlowsFromOperatingActivitiesUS) ||
      get_item_form_result(result, :CashFlowsFromOperatingActivitiesIFRS)
    )
    check_and_merge([
      value  
    ])
  end

end
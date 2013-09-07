require_relative 'Formats'

class NetOperationgRevenues < Formats
  
  def self.calculate(result)

    value = get_item_form_result(result, :NetSales) || get_item_form_result(result, :OperatingRevenue1)
    
    check_and_merge([
      value
    ])
  end

end
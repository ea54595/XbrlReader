require_relative 'Formats'

class TotalLiabilitiesAndEquity < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :Assets)
    ])
  end
end
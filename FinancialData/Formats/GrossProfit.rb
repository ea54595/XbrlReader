require_relative 'Formats'

class GrossProfit < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :GrossProfit)
    ])
  end
end
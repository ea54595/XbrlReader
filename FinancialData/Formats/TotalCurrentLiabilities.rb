require_relative 'Formats'

class TotalCurrentLiabilities < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :Liabilities)
    ])
  end
end
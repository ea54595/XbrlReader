require_relative 'Formats'

class OperatingIncome < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :OperatingIncome)
    ])
  end

end
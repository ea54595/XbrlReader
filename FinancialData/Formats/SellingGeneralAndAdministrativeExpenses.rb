require_relative 'Formats'

class SellingGeneralAndAdministrativeExpenses < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :SellingGeneralAndAdministrativeExpenses)
    ])
  end

end
require_relative 'FommatterModule'

class SellingGeneralAndAdministrativeExpenses
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :SellingGeneralAndAdministrativeExpenses)
    ])
  end

end
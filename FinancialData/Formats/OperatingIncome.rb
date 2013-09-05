require_relative 'FommatterModule'

class OperatingIncome
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :OperatingIncome)
    ])
  end

end
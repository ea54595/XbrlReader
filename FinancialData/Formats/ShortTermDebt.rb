require_relative 'Formats'

class ShortTermDebt < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :ShortTermLoansPayable),
      get_item_form_result(result, :CurrentPortionOfLongTermLoansPayable),
      get_item_form_result(result, :CurrentPortionOfBonds)
    ])
  end
end
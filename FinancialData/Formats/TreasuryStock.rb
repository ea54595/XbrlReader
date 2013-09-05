require_relative 'FommatterModule'

class TreasuryStock
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :TreasuryStock)
    ])
  end
end
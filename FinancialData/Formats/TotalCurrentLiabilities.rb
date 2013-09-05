require_relative 'FommatterModule'

class TotalCurrentLiabilities
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :Liabilities)
    ])
  end
end
require_relative 'FommatterModule'

class IncomeTaxes
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :IncomeTaxes)
    ])
  end
end
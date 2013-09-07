require_relative 'Formats'

class IncomeTaxes < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :IncomeTaxes)
    ])
  end
end
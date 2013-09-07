require_relative 'Formats'

class TreasuryStock < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :TreasuryStock)
    ])
  end
end
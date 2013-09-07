require_relative 'Formats'

class ShareholdersEquity < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :ShareholdersEquity)
    ])
  end
end
require_relative 'FommatterModule'

class ShareholdersEquity
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :ShareholdersEquity)
    ])
  end
end
require_relative 'FommatterModule'

class NameRepresentative
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :NameRepresentative)
    ])
  end

end
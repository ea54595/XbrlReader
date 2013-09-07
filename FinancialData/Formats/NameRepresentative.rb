require_relative 'Formats'

class NameRepresentative < Formats
  
  def self.calculate(result)
    parse_representive(
      get_item_form_result(result, :NameRepresentative)
    )
  end

end
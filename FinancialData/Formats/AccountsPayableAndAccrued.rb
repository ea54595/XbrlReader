require_relative 'Formats'

class AccountsPayableAndAccrued < Formats
  
  def self.calculate(result)
    check_and_merge([
      get_item_form_result(result, :AccountsPayableTrade),
      get_item_form_result(result, :NotesAndAccountsPayableTrade)
    ])
  end

end
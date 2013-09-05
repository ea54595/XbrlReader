require_relative 'FommatterModule'

class AccountsPayableAndAccrued
  include FommatterModule
  
  def self.calcuate(result)
    check_and_merge([
      get_item_form_result(result, :AccountsPayableTrade),
      get_item_form_result(result, :NotesAndAccountsPayableTrade),
    ])
  end

end